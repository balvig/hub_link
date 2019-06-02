require "pastel"
require "hub_link/api/pull_request"

module HubLink
  class Batch
    attr_reader :options

    def initialize(options = {})
      @options = options.compact
    end

    def empty?
      results.empty?
    end

    def fetch(resource)
      public_send(resource)
    end

    def pull_requests
      log "Fetching pull requests" do
        results.map(&:to_h)
      end
    end

    def reviews
      log "Fetching reviews" do
        results.flat_map(&:reviews).map(&:to_h)
      end
    end

    def review_requests
      log "Fetching review requests" do
        results.flat_map(&:review_requests).map(&:to_h)
      end
    end

    private

      def results
        @_results ||= fetch_results
      end

      def log(title, &block)
        logger.info(START) { title }

        block.call.tap do |results|
          logger.info(FINISH) { pastel.green("Found #{results.size}") }
        end
      end

      def fetch_results
        log pastel.bold("Getting PRs: #{formatted_options}") do
          Api::PullRequest.list(options)
        end
      end

      def formatted_options
        options.values.join(", ")
      end

      def logger
        HubLink.logger
      end

      def pastel
        @_pastel ||= Pastel.new
      end
  end
end
