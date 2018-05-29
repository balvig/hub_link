module Mergometer
  module Reports
    class PrTrendReportEntry
      attr_reader :values

      def initialize(values)
        @values = values
      end

      def average
        @average ||= Math.mean(values).round(2)
      end

      def sum
        @sum ||= values.sum
      end

      def count
        @count ||= values.size.to_f
      end
    end
  end
end
