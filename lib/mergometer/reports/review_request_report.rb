require "mergometer/github_report"

module Mergometer
  module Reports
    class ReviewRequestReport < GithubReport
      COLUMNS = %i(id created_at reviewer)
      GITHUB_API_CHUNK = 14

      def initialize(repo)
        super repo: repo, query: prs_past_year, columns: COLUMNS do |prs|
          prs.flat_map(&:review_requests)
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
          Date.today
        end
    end
  end
end
