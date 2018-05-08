require "mergometer/report"
require "mergometer/reports/weekly_report_entry"

module Mergometer
  module Reports
    class WeeklyReport < Report
      def render
        super
        puts "Median num of PRs/week: #{median}"
      end

      private

        def fields
          %i(week count)
        end

        def entries
          @_entries ||= build_entries
        end

        def filter
          "#{repo_query} type:pr created:<=#{Time.current.last_week.end_of_week.to_date}"
        end

        def build_entries
          prs.group_by(&:week).map do |week, weekly_prs|
            WeeklyReportEntry.new(week: week, prs: weekly_prs)
          end
        end

        def median
          Math.median entries.map(&:count)
        end
    end
  end
end
