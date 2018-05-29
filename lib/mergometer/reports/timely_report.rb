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

      def data_sets
        @data_sets ||= entries.map do |k, v|
          [k, [v.send(:count)]]
        end.to_h
      end

      def median
        Math.median(entries.map(&:count)).round(2)
      end

      def entries
        grouped_prs_by_time.map do |week, weekly_prs|
          [week.strftime("%Y-%m-%d"), TimelyReportEntry.new(prs: weekly_prs)]
        end.to_h
      end

      def add_total?
        false
      end

      def add_average?
        false
      end
    end
  end
end
