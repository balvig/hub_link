module Mergometer
  module Reports
    class RankingReport < BaseReport
      METRICS = %i(eligible_pr_count average_comment_count average_changes average_merge_time
                   heavily_commented_count problem_ratio review_required_count).freeze

      private

        def first_column_name
          "Metric"
        end

        def table_keys
          @table_keys ||= grouped_prs_by_user.keys
        end

        def data_sets
          @data_sets ||= (METRICS.map do |metric|
            [metric.to_s, eligible_rankings.map do |_user, rankings|
              rankings.send(metric)
            end]
          end + [["number_of_given_reviews_by_user", eligible_rankings.keys.map do |user|
            grouped_prs_by_reviewer[user]&.count || 0
          end]]).to_h
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
