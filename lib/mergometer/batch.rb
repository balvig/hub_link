module Mergometer
  class Batch
    def initialize(query)
      @query = query
    end

    def pull_requests
      results.map(&:to_h)
    end

    def reviews
      results.flat_map(&:reviews).map(&:to_h)
    end

    def review_requests
      results.flat_map(&:review_requests).map(&:to_h)
    end

    private

      attr_reader :query

      def results
        @_results ||= Api::PullRequest.search(query)
      end
  end
end
