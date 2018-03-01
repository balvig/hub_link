module Mergometer
  module Reports
    class PrTrendReportEntry
      attr_reader :date

      def initialize(date, values)
        @date = date
        @values = values
      end

      def value
        average
      end

      private

        def average
          @_average ||= values.sum / values.size
        end

        attr_reader :values
    end
  end
end
