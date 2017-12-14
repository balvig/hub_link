require "mergometer/report"
require "mergometer/reports/merge_trend_report_entry"

module Mergometer
  module Reports
    class MergeTrendReport < Report
      private

        def fields
          %i(date median_merge_time)
        end

        def entries
          super.map do |pr|
            pr.group_by.created_at.to_date do |date, prs|
              MergeTrendReportEntry.new(date, prs)
            end
          end
        end

        def filter
          "repo:#{repo} type:pr is:merged created:>=#{24.weeks.ago.to_date}"
        end
    end
  end
end
