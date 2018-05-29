module Mergometer
  module Reports
    class TimelyReport < BaseReport
      def print_report
        super
        puts "Median num of PRs/week: #{median}"
      end

      private

      def first_column_name
        "Date (by #{@group_by})"
      end

      def table_keys
        ["PR opened"]
      end

      def median
        Math.median(data_sets.values.first).round(2)
      end

      def data_sets
        @data_sets ||= grouped_prs_by_time.map do |time, timely_prs|
          [time.strftime("%Y-%m-%d"), [timely_prs.count]]
        end.to_h
      end

      def show_total?
        false
      end

      def show_average?
        false
      end

      def prs
        @prs
      end
    end
  end
end
