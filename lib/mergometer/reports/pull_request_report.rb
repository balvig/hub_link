require "mergometer/reports/csv_report"

module Mergometer
  module Reports
    class PullRequestReport < CsvReport
      COLUMNS = %i(
        id
        number
        created_at
        approval_time
        time_to_first_review
        merge_time
        body_size
        additions
        review_count
        submitter
        straight_approval?
        repo
      )

      def initialize(prs)
        super records: prs, columns: COLUMNS
      end
    end
  end
end
