require "mergometer/reports/report"

module Mergometer
  module Reports
    class PullRequestReport < Report
      COLUMNS = %i(
        id
        number
        created_at
        closed_at
        approval_time
        time_to_first_review
        merge_time
        body_size
        additions
        review_count
        submitter
        straight_approval?
        labels
        repo
      )

      def initialize(queries)
        super queries: queries, columns: COLUMNS
      end
    end
  end
end
