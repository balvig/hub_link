require "mergometer/pull_request"

module Mergometer
  class Report
    require "hirb"

    def initialize(repo)
      @repo = repo
    end

    def render
      puts Hirb::Helpers::AutoTable.render(
        entries,
        unicode: true,
        fields: fields,
        description: false
      )

      puts "Total number of PRs checked: #{prs.size}"
    end

    private

      attr_accessor :repo

      def fields
        raise "Implement fields method"
      end

      def entries
        raise "Implement entries method"
      end

      def filter
        "base:master repo:#{repo} type:pr is:merged"
      end

      def prs
        @_prs ||= items.map { |item| PullRequest.new(item) }
      end

      def items
        Octokit.search_issues(filter).items
      end
  end
end
