require "mergometer/pull_request"
require "mergometer/report"

module Mergometer
  class GithubReport < Report
    def initialize(repo:, query:, columns:, &block)
      @repo = repo
      @query = query
      @columns = columns
      @source = yield(prs)
    end

    private

      attr_accessor :repo, :query

      def prs
        @_prs ||= fetch_prs
      end

      def fetch_prs
        Array(query).flat_map do |query|
          PullRequest.search "#{query} #{repo_query}"
        end
      end

      def repo_query
        @_repo_query = repo.split(",").map do |r|
          "repo:#{r}"
        end.join(" ")
      end
  end
end
