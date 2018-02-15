require "gruff"
require "mergometer/report"
require "mergometer/reports/merge_trend_report_entry"

module Mergometer
  module Reports
    class MergeTrendReport < Report
      METRICS = %i(approval_time time_to_first_review merge_time)
      GROUPING = :week

      def render
        graph.labels = labels
        graph.hide_dots = true
        graph.marker_font_size = 10
        graph.legend_font_size = graph.marker_font_size

        METRICS.each do |metric|
          entries = grouped_prs.map do |date, prs|
            MergeTrendReportEntry.new(date, prs.map(&metric))
          end

          graph.data(metric.to_s, entries.map(&:value))
        end

        graph.write("merge_trend_report.png")
      end

      private

        def fields_to_preload
          METRICS
        end

        def graph
          @_graph ||= Gruff::Line.new("1000x600")
        end

        def labels
          grouped_prs.keys.each_with_index.inject({}) do |result, (time, index)|
            if index % 4 == 0
              result[index] = time.to_date
            end

            result
          end
        end

        def grouped_prs
          @_grouped_prs ||= eligible_prs.sort_by(&GROUPING).group_by(&GROUPING)
        end

        def eligible_prs
          prs.reject do |pr|
            METRICS.any? do |metric|
              pr.public_send(metric).blank?
            end
          end
        end

        def filter
          [
            "repo:#{repo} type:pr review:approved created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "repo:#{repo} type:pr review:approved created:>=#{26.weeks.ago.to_date}"
          ]
        end
    end
  end
end
