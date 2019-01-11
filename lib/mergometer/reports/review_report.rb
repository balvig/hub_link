require "mergometer/reports/report"

module Mergometer
  module Reports
    class ReviewReport < Report
      COLUMNS = %i(
        id
        pull_request_id
        submitted_at
        reviewer
        approval?
      )

      def initialize(queries)
        super queries: queries, columns: COLUMNS
      end

      private

        def fetch_results(query)
          super.flat_map(&:reviews)
        end
    end
  end
end
