require "mergometer/reports/report"

module Mergometer
  module Reports
    class ReviewRequestReport < Report
      COLUMNS = %i(
        id
        created_at
        reviewer
      )

      def initialize(queries)
        super queries: queries, columns: COLUMNS
      end

      private

        def fetch_results(query)
          super.flat_map(&:review_requests)
        end
    end
  end
end
