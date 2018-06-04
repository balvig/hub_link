module Mergometer
  module Reports
    class IndividualReviewReport < BaseReport
      def print_report
        super
        puts "PRs awaiting review: #{review_required_count}"
      end

      def review_required_count
        prs.select(&:review_required?).size
      end

      private

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

        def prs
          @prs
        end
    end
  end
end
