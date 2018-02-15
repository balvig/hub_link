module Mergometer
  module Reports
    class MergeTrendReportEntry
      TRUNCATION_LIMIT = 130

      attr_reader :date

      def initialize(date, values)
        @date = date
        @values = values
      end

      def value
        if actual_value > TRUNCATION_LIMIT
          TRUNCATION_LIMIT
        else
          actual_value
        end
      end

      private

        def actual_value
          @_actual_value ||= values.sum / values.size
        end

        attr_reader :values
    end
  end
end
