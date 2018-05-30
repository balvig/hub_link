module Mergometer
  module Reports
    class RankingReport < BaseReport
      METRICS = %i(eligible_pr_count average_comment_count average_changes average_merge_time
                   heavily_commented_count problem_ratio review_required_count reviews_to_prs_count).freeze

      private

        def first_column_name
          "Metric"
        end

        def table_keys
          @table_keys ||= eligible_rankings.keys
        end

        def data_sets
          @data_sets ||= METRICS.map do |metric|
            [metric.to_s, eligible_rankings.map do |_user, rankings|
              rankings.send(metric)
            end]
          end.to_h
        end

        def eligible_rankings
          all_rankings.reject { |_k, v| v.inactive? }
        end

        def all_rankings
          @all_rankings ||= grouped_prs_by_user.map do |user, user_prs|
            [user, PullRequests.new(user_prs)]
          end.to_h
        end

        def show_total?
          false
        end

        def prs
          @prs
        end
    end
  end
end
