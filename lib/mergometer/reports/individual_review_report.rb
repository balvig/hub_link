module Mergometer
  module Reports
    class IndividualReviewReport < BaseReport
      private

        def first_column_name
          "username"
        end

        def table_keys
          @table_keys ||= grouped_entries_by_time_and_reviewer.keys.map(&:to_date).map { |d| d.strftime("%Y-%m-%d") }
        end

        def data_sets
          @_data_sets ||= grouped_entries_by_time_and_reviewer.values.flatten.group_by(&:user).map do |k, v|
            [k, v.map(&:count)]
          end.to_h
        end
    end
  end
end
