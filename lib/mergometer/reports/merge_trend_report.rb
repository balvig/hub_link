require "mergometer/report"
require "mergometer/reports/merge_trend_report_entry"

module Mergometer
  module Reports
    class MergeTrendReport < Report
      METRICS = %i(approval_time merge_time)
      GROUPING = :week

      def render
        graph.labels = labels

        METRICS.each do |metric|
          entries = grouped_prs.map do |date, prs|
            MergeTrendReportEntry.new(date, prs.map(&metric))
          end

          graph.data(metric.to_s, entries.map(&:value))
        end

        graph.write("output.png")
      end

      private

        def fields_to_preload
          METRICS
        end

        def graph
          @_graph ||= Gruff::Area.new(800)
        end

        def labels
          {
            0 => grouped_prs.keys.first.to_date,
            grouped_prs.size - 1 => grouped_prs.keys.last.to_date
          }
        end

        def grouped_prs
          eligible_prs.sort_by(&GROUPING).group_by(&GROUPING)
        end

        def eligible_prs
          prs.reject do |pr|
            METRICS.any? do |metric|
              pr.public_send(metric).blank?
            end
          end
        end

        def prs
          @_prs ||= fetch_prs
        end

        def fetch_prs
          filters.flat_map do |filter|
            PullRequest.search(filter)
          end
        end

        def filters
          [
            "repo:#{repo} type:pr review:approved created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "repo:#{repo} type:pr review:approved created:>=#{26.weeks.ago.to_date}"
          ]
        end
    end
  end
end
