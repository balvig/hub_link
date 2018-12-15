require "csv"

module Mergometer
  module Reports
    class Report
      def initialize(records:, columns:)
        @records = records
        @columns = columns
      end

      def export_csv
        CSV.open(csv_file_name, "w", write_headers: true, headers: columns) do |csv|
          rows.each do |row|
            csv << row.values
          end
        end
      end

      def rows
        records.map do |record|
          columns.inject({}) do |result, column|
            result.merge(column => record.public_send(column))
          end
        end
      end

      private

        attr_accessor :records, :columns

        def csv_file_name
          self.class.to_s.demodulize.underscore + ".csv"
        end
    end
  end
end
