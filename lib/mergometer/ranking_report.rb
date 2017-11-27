require "mergometer/report"
require "mergometer/ranking"

module Mergometer
  class RankingReport < Report
    METRICS = %i(eligible_pr_count comment_count changes heavily_commented_count problem_ratio num_of_given_reviews)

    def render
      puts "Metrics: #{METRICS.join(", ")}"
      super
    end

    private

      def fields
        [:user] + METRICS
      end

      def entries
        @_entries ||= sorted_rankings
      end

      def sorted_rankings
        eligible_rankings.sort_by(&sort_field).reverse
      end

      def eligible_rankings
        all_rankings.reject(&:inactive?)
      end

      def sort_field
        METRICS.first
      end

      def all_rankings
        @_all_rankings ||= build_rankings
      end

      def build_rankings
        prs.group_by(&:user).map do |user, user_prs|
          Ranking.new(user: user, prs: user_prs, repo: repo)
        end
      end
  end
end
