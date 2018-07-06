require "csv"
require "mergometer/report"

module Mergometer
  module Reports
    class PrTrendReport < Report
      METRICS = %i(approval_time time_to_first_review merge_time body_size additions review_count)
      GITHUB_API_CHUNK = 14

      def render
        CSV.open("pr_trend_report.csv", "w", write_headers: true, headers: csv_headers) do |csv|
          eligible_prs.each do |pr|
            csv << [pr.created_at] + METRICS.map do |metric|
              pr.public_send(metric)
            end
          end
        end

        puts "CSV exported."
      end

      private

        def csv_headers
          ["Date"] + METRICS
        end

        def fields_to_preload
          METRICS
        end

        def eligible_prs
          prs.reject do |pr|
            METRICS.any? do |metric|
              pr.public_send(metric).blank?
            end
          end
        end

        def filter
          start_date.step(end_date, GITHUB_API_CHUNK).map do |date|
            "#{repo_query} type:pr created:#{date}..#{date + GITHUB_API_CHUNK}"
          end
        end

        def start_date
          52.weeks.ago.to_date
        end

        def end_date
          1.week.ago.to_date
        end
    end
  end
end
