module Mergometer
  class Report
    require "hirb"
    require "progress_bar"

    def initialize(repo, metric:)
      @repo = repo
      @metric = metric
    end

    def render
      puts "Metric: #{metric}"
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

      attr_accessor :repo, :metric

      def preload
        bar = ProgressBar.new(prs.size, :bar, :counter, :elapsed)
        prs.each do |pr|
          pr.public_send(metric)
          bar.increment!
        end
      end

      def fields
        headers.keys + [metric]
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
          [ranking.send(metric), -ranking.eligible_pr_count]
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
  end
end
