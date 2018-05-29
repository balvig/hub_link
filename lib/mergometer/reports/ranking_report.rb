module Mergometer
  module Reports
    class RankingReport < BaseReport
      METRICS = %i(eligible_pr_count average_comment_count average_changes average_merge_time
                   heavily_commented_count problem_ratio).freeze

      private

        def first_column_name
          "Metric"
        end

        def table_keys
          @table_keys ||= grouped_prs_by_users.keys
        end

        def data_sets
          @data_sets ||= (METRICS.map do |metric|
            [metric.to_s, eligible_rankings.map do |_user, rankings|
              rankings.send(metric)
            end]
          end + [["number_of_given_reviews", eligible_rankings.keys.map do |user|
            grouped_prs_by_reviewer[user]&.count || 0
          end]]).to_h
        end

        def eligible_rankings
          all_rankings.reject { |_k, v| v.inactive? }
        end

        def all_rankings
          @all_rankings ||= grouped_prs_by_users.map do |user, user_prs|
            [user, PrReportEntry.new(user_prs)]
          end.to_h
        end

        def show_total?
          false
        end
    end
  end
end
