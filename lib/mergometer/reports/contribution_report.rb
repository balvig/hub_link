module Mergometer
  module Reports
    class ContributionReport < BaseReport
      private

        def first_column_name
          "username"
        end

        def table_keys
          @table_keys ||= grouped_prs_by_time_and_user.keys.map do |d|
            d.strftime("%Y-%m-%d")
          end
        end

        def data_sets
          @data_sets ||= grouped_prs_by_time_and_user.values.first.keys.map do |user|
            [user, grouped_prs_by_time_and_user.values.map { |grouped| grouped[user].count }]
          end.to_h
        end

        def prs
          @prs
        end
    end
  end
end
