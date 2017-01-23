module Mergometer
  class Report
    require "hirb"
    require "progress_bar"

    def initialize(repo, metrics:)
      @repo = repo
      @metrics = metrics
    end

    def render
      puts "Metrics: #{metrics.join(", ")}"
      preload
      puts Hirb::Helpers::AutoTable.render(
        rankings,
        unicode: true,
        fields: fields,
        headers: headers,
        description: false
      )

      puts "Total number of PRs checked: #{prs.size}"
    end

    private

      attr_accessor :repo, :metrics

      def fields
        headers.keys + metrics
      end

      def headers
        {
          user: "Name",
          counts: "PR counts"
        }
      end

      def prs
        @_prs ||= items.map { |item| PullRequest.new(item) }
      end

      def prs_grouped_by_user
        prs.group_by(&:user)
      end

      def rankings
        @_rankings ||= sorted_rankings
      end

      def sorted_rankings
        eligible_rankings.sort_by do |ranking|
          [ranking.send(metrics.first), -ranking.eligible_pr_count]
        end
      end

      def eligible_rankings
        all_rankings.reject(&:inactive?)
      end

      def all_rankings
        @_all_rankings ||= prs.group_by(&:user).map { |user, user_prs| Ranking.new(user, prs: user_prs) }
      end

      def items
        Octokit.search_issues("base:master repo:#{repo} type:pr is:merged").items
      end

      def preload
        prs.each do |pr|
          pr.preload
          progress_bar.increment!
        end
      end

      def progress_bar
        @_progress_bar ||= ProgressBar.new(prs.size, :bar, :counter, :elapsed)
      end
  end
end
