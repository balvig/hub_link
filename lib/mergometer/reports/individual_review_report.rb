module Mergometer
  module Reports
    class IndividualReviewReport < BaseReport
      private

        def load_reviews?
          true
        end

        def first_column_name
          "username"
        end

        def table_keys
          @table_keys ||= grouped_prs_by_time_and_reviewer.keys.map { |d| d.strftime("%Y-%m-%d") }
        end

        def data_sets
          @data_sets ||= grouped_prs_by_time_and_reviewer.values.first.keys.map do |user|
            [user, grouped_prs_by_time_and_reviewer.values.map { |grouped| grouped[user].count }]
          end.to_h
        end

        def group_by
          "updated_#{@group_by}"
        end

        def prs
          updated_prs.merged_prs
        end
    end
  end
end
