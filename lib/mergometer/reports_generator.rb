require "mergometer/api/pull_request"
require "mergometer/reports/pull_request_report"
require "mergometer/reports/review_report"
require "mergometer/reports/review_request_report"

module Mergometer
  class ReportsGenerator
    GITHUB_API_CHUNK = 14

    def initialize(repos)
      @repos = repos
    end

    def run
      Reports::PullRequestReport.new(prs).save
      Reports::ReviewReport.new(prs).save
      Reports::ReviewRequestReport.new(prs).save
    end

    private

      attr_accessor :repos

      def prs
        @_prs ||= fetch_prs
      end

      def fetch_prs
        queries.flat_map do |query|
          Api::PullRequest.search "#{query} #{repo_query}"
        end
      end

      def queries
        start_date.step(end_date, GITHUB_API_CHUNK).map do |date|
          "type:pr created:#{date}..#{date + GITHUB_API_CHUNK}"
        end
      end

      def start_date
        64.weeks.ago.to_date
      end

      def end_date
        Date.today
      end

      def repo_query
        @_repo_query = build_repo_query
      end

      def build_repo_query
        repos.split(",").map do |r|
          "repo:#{r}"
        end.join(" ")
      end
  end
end
