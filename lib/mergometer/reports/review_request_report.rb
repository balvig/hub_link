require "mergometer/reports/csv_report"

module Mergometer
  module Reports
    class ReviewRequestReport < CsvReport
      COLUMNS = %i(
        id
        created_at
        reviewer
      )

      def initialize(prs)
        super records: prs.flat_map(&:review_requests), columns: COLUMNS
      end
    end
  end
end
