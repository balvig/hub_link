module Mergometer
  module Reports
    class ReviewReport < BaseReport
      def print_report
        super
        puts "PRs awaiting review: #{prs.size}"
      end

      private

        def first_column_name
          "username"
        end

        def table_keys
          @table_keys ||= grouped_entries_by_time_and_user.keys.map(&:to_date).map { |d| d.strftime("%Y-%m-%d") }
        end

        def data_sets
          @data_sets ||= grouped_entries_by_time_and_user.values.flatten.group_by(&:user).map do |k, v|
            [k, v.map(&:count)]
          end.to_h
        end

        def prs
          @prs.select(&:review_required?)
        end
    end
  end
end
