require "mergometer/github_report"

module Mergometer
  module Reports
    class ReviewReport < GithubReport
      COLUMNS = %i(id pull_request_id submitted_at reviewer approval?)
      GITHUB_API_CHUNK = 14

      def initialize(repo)
        super repo: repo, query: prs_past_year, columns: COLUMNS do |prs|
          prs.flat_map(&:reviews)
        end
      end

      private

        def prs_past_year
          start_date.step(end_date, GITHUB_API_CHUNK).map do |date|
            "type:pr created:#{date}..#{date + GITHUB_API_CHUNK}"
          end
        end

        def start_date
          4.weeks.ago.to_date
        end

        def end_date
          Date.today
        end
    end
  end
end
