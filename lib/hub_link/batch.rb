require "hub_link/api/issue"

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
        pull_request_results.find_all(&:pull_request?).map(&:to_h)
      end
    end

    def reviews
      log "Fetching reviews" do
        pull_request_results.flat_map(&:reviews).map(&:to_h)
      end
    end

    def issues
      log "Fetching issues" do
        (results - pull_request_results).map(&:to_h)
      end
    end

    private

      def pull_request_results
        @_pull_request_results ||= results.find_all(&:pull_request?)
      end

      def results
        @_results ||= fetch_results
      end

      def fetch_results
        log "*Querying issues* #{formatted_options}" do
          Api::Issue.list(**options)
        end
      end

      def log(title, &block)
        logger.info(START) { title }

        block.call.tap do |results|
          logger.info(FINISH) { "Found #{results.size}" }
        end
      end

      def formatted_options
        options.values.join(", ")
      end

      def logger
        HubLink.logger
      end
  end
end
