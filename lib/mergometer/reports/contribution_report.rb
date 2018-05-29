require "csv"
require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class ContributionReport < BaseReport
      private

        def first_column_name
          "username"
        end

        def table_keys
          @_table_keys ||= grouped_entries_by_time_and_user.keys.map(&:to_date).map do |d|
            d.strftime("%Y-%m-%d")
          end
        end

        def data_sets
          @_data_sets ||= grouped_entries_by_time_and_user.values.flatten.group_by(&:user).map do |k, v|
            [k, v.map(&:count)]
          end.to_h
        end
    end
  end
end
