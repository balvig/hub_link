module Mergometer
  module Reports
    class PrTrendReportEntry
      attr_reader :date

      def initialize(values)
        @values = values
      end

      def average
        (sum / count).round(2)
      end

      private

        attr_reader :values

        def sum
          @sum ||= values.sum
        end

        def count
          @count ||= values.size.to_f
        end
    end
  end
end
