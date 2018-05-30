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
          @table_keys ||= grouped_prs_by_time_and_user.keys.map(&:to_date).map { |d| d.strftime("%Y-%m-%d") }
        end

        def data_sets
          @data_sets ||= grouped_prs_by_time_and_user.values.first.keys.map do |user|
            [user, grouped_prs_by_time_and_user.values.map { |grouped| grouped[user].count }]
          end.to_h
        end

        def prs
          @prs.select(&:review_required?)
        end
    end
  end
end
