require "mergometer/reports/csv_report"

module Mergometer
  module Reports
    class ReviewReport < CsvReport
      COLUMNS = %i(
        id
        pull_request_id
        submitted_at
        reviewer
        approval?
      )

      def initialize(prs)
        super records: prs.flat_map(&:reviews), columns: COLUMNS
      end
    end
  end
end
