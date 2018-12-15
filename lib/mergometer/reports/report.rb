require "csv"

module Mergometer
  module Reports
    class Report
      def initialize(records:, columns:)
        @records = records
        @columns = columns
      end

      def save
        export_csv
      end

      def to_rows
        records.map do |record|
          columns.inject({}) do |result, column|
            result.merge(column => record.public_send(column))
          end
        end
      end

      private

        attr_accessor :records, :columns

        def export_csv
          CSV.open(csv_file_name, "w", write_headers: true, headers: columns) do |csv|
            csv_data.each do |data|
              csv << data
            end
          end
        end

        def csv_file_name
          self.class.to_s.demodulize.underscore + ".csv"
        end

        def csv_data
          records.map do |record|
            columns.map do |column|
              record.public_send(column)
            end
          end
        end
    end
  end
end
