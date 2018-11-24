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
      )

      def initialize(prs)
        super records: prs, columns: COLUMNS
      end
          #prs.reject do |pr|
            #COLUMNS.any? do |metric|
              #pr.public_send(metric).nil?
            #end
          #end
    end
  end
end
