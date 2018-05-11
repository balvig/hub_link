require "mergometer/report"
require "mergometer/reports/ranking_report_entry"

module Mergometer
  module Reports
    class RankingReport < Report
      METRICS = %i(eligible_pr_count median_comment_count heavily_commented_count problem_ratio num_of_given_reviews)

      def render
        puts "Metrics: #{METRICS.join(", ")}"
        super
      end

      private

        def fields_to_preload
          %i(quick_fix?)
        end

        def fields
          [:user] + METRICS
        end

        def entries
          eligible_rankings
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
            RankingReportEntry.new(user: user, prs: user_prs, repo: repo)
          end
        end
    end
  end
end
