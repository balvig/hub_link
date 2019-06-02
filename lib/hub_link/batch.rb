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
          logger.info(FINISH) { "Found #{results.size}" }
        end
      end

      def fetch_results
        log "Getting page: #{options.values.join(', ')}" do
          Api::PullRequest.list(options)
        end
      end

      def logger
        HubLink.logger
      end
  end
end
