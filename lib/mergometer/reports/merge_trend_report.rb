require "mergometer/report"
require "mergometer/reports/merge_trend_report_entry"

module Mergometer
  module Reports
    class MergeTrendReport < Report
      def render
        graph.labels = entries.map do |entry|
          entry.date.strftime("%b")
        end.map.with_index { |x, i| [i, x] }.to_h

        graph.data("Merge Time", entries.map(&:median_merge_time))
        graph.data("Num of merged PRs", entries.map(&:pr_count))

        graph.write("merge_trend.png")
      end

      private

        def graph
          @_graph ||= Gruff::Line.new(800)
        end

        def entries
          super.sort_by(&:month).group_by(&:month).map do |date, prs|
            MergeTrendReportEntry.new(date, prs)
          end
        end

        def filter
          "repo:#{repo} type:pr is:merged created:>=#{12.weeks.ago.beginning_of_month.to_date}"
        end
    end
  end
end
