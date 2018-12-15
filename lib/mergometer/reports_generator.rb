require "mergometer/api/pull_request"
require "mergometer/reports/pull_request_report"
require "mergometer/reports/review_report"
require "mergometer/reports/review_request_report"

module Mergometer
  class ReportsGenerator
    GITHUB_API_CHUNK = 14

    def initialize(repos, start_date: 64.weeks.ago)
      @repos = repos.split(",")
      @start_date = start_date.to_date
    end

    def run
      pull_request_report.export_csv
      review_report.export_csv
      review_request_report.export_csv
    end

    def pull_request_report
      Reports::PullRequestReport.new(prs)
    end

    def review_report
      Reports::ReviewReport.new(prs)
    end

    def review_request_report
      Reports::ReviewRequestReport.new(prs)
    end

    private

      attr_accessor :repos, :start_date

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

      def end_date
        Date.tomorrow
      end

      def repo_query
        @_repo_query = build_repo_query
      end

      def build_repo_query
        repos.map do |r|
          "repo:#{r}"
        end.join(" ")
      end
  end
end
