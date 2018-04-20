module Mergometer
  module Reports
    class Report
      def save_to_csv
        CSV.open("#{name}.csv", "w") do |csv|
          csv << table_entries.first.keys
          table_entries.each do |hash|
            csv << hash.values
          end
        end

        puts "#{name} CSV exported."
      end

      def print_report
        p Hirb::Helpers::Table.render(table_entries, resize: false)
      end

      def to_h
        table_entries
      end

      def average
        @_average ||= data_sets.map do |user, entries|
          [user, entries.map(&:count).reduce(:+) / entries.size.to_f]
        end.to_h
      end

      def sum
        @_sum ||= data_sets.map do |user, entries|
          [user, entries.map(&:count).reduce(:+)]
        end.to_h
      end

      private

        def name
          "Report"
        end
    end
  end
end