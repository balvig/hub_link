require "mergometer/report"
require "mergometer/reports/merge_trend_report_entry"

module Mergometer
  module Reports
    class MergeTrendReport < Report
      def render
        graph.labels = entries.map do |entry|
          entry.date.strftime("%b")
        end.map.with_index { |x, i| [i, x] }.to_h

        graph.data("Time to approval", entries.map(&:value))
        graph.write("merge_trend.png")
      end

      private

        def fields_to_preload
          %i(approval_time)
        end

        def graph
          @_graph ||= Gruff::Line.new(800)
        end

        def entries
          eligible_prs.sort_by(&:month).group_by(&:month).map do |date, prs|
            MergeTrendReportEntry.new(date, prs)
          end
        end

        def eligible_prs
          prs.reject do |pr|
            pr.approval_time.blank?
          end
        end

        def filter
          "repo:#{repo} type:pr is:merged review:approved created:>=#{26.weeks.ago.beginning_of_month.to_date}"
        end
    end
  end
end
