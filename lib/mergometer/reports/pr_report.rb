require "csv"
require "mergometer/report"

module Mergometer
  module Reports
    class PrReport < Report
      COLUMNS = %i(created_at approval_time time_to_first_review merge_time body_size additions review_count submitter)
      GITHUB_API_CHUNK = 14

      def initialize(repo)
        super repo: repo, query: prs_past_year, columns: COLUMNS do |prs|
          prs.reject do |pr|
            COLUMNS.any? do |metric|
              pr.public_send(metric).blank?
            end
          end
        end
      end

      private

        def prs_past_year
          start_date.step(end_date, GITHUB_API_CHUNK).map do |date|
            "type:pr created:#{date}..#{date + GITHUB_API_CHUNK}"
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
