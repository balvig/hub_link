module Mergometer
  class Report
    require "hirb"

    def initialize(repo)
      @repo = repo
    end

    def render
      puts Hirb::Helpers::AutoTable.render(
        rankings,
        unicode: true,
        fields: fields,
        headers: headers,
        description: false
      )

      puts "Total number of PRs checked: #{prs.size}"
      puts "Total median merge time: #{total_median.in_words}"
    end

    private

      attr_accessor :repo

      def fields
        headers.keys
      end

      def headers
        {
          user: "Name",
          total_count: "PR count",
          formatted_merge_time: "Median merge time",
          formatted_slowest_merge: "Slowest"
        }
      end

      def prs
        @_prs ||= items.map { |item| PullRequest.new(item) }
      end

      def prs_grouped_by_user
        prs.group_by(&:user)
      end

      def rankings
        @_rankings ||= build_rankings
      end

      def build_rankings
        rankings = prs_grouped_by_user.map { |user, user_prs| Ranking.new(user, prs: user_prs) }
        #rankings = rankings.reject(&:inactive?)
        rankings = rankings.sort_by(&:median_merge_time)
        rankings
      end

      def total_median
        Math.median prs.map(&:merge_time)
      end

      def items
        Octokit.search_issues("base:master repo:#{repo} type:pr is:merged", per_page: 10).items
      end
  end
end
