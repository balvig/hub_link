require "csv"
require "mergometer/report"
require "mergometer/reports/pr_trend_report_entry"

module Mergometer
  module Reports
    class PrTrendReport < Report
      METRICS = %i(approval_time time_to_first_review merge_time body_size additions)
      GROUPING = :week

      def render
        CSV.open("pr_trend_report.csv", "w", headers: csv_headers) do |csv|
          METRICS.each do |metric|
            entries = grouped_prs.map do |date, prs|
              PrTrendReportEntry.new(date, prs.map(&metric))
            end

            csv << [metric.to_s] + entries.map(&:value)
          end
        end

        puts "CSV exported."
      end

      private

        def csv_headers
          [nil] + grouped_prs.keys.map(&:to_date)
        end

        def fields_to_preload
          METRICS
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
            "#{repo_query} type:pr created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "#{repo_query} type:pr created:#{26.weeks.ago.to_date}..#{1.week.ago.to_date}"
          ]
        end
    end
  end
end
