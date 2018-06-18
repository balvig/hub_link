module Mergometer
  module Reports
    class UserReport < BaseReport
      METRICS = %i(eligible_pr_count average_comment_count average_changes average_merge_time
                   heavily_commented_count problem_ratio review_required_count reviews_to_prs_count).freeze

      def initialize(prs, **options)
        @user = options[:user]
        raise 'Need `user` parameter' unless @user
        super(prs, **options)
      end

      private

        attr_reader :user

        def first_column_name
          "Metric"
        end

        def table_keys
          @table_keys ||= RankingReport.new(prs).to_h.map { |h| h["Metric"] }
        end

        def data_sets
          @data_sets ||= grouped_prs_by_time.map do |time, prs|
            ranking_report = RankingReport.new(prs).to_h
            [time, ranking_report.map { |r| r[user] }]
          end
        end

        def prs
          @prs
        end

        def show_total?
          false
        end

        def show_average?
          false
        end
    end
  end
end
