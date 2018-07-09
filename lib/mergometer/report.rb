require "csv"

module Mergometer
  class Report
    def initialize(columns:, source:)
      @columns = columns
      @source = source
    end

    def run
      export_csv
      puts "#{csv_file_name} exported."
    end

    private

      attr_accessor :columns, :source

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
        source.map do |record|
          columns.map do |column|
            record.public_send(column)
          end
        end
      end
  end
end
