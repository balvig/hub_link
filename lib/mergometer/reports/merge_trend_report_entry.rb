module Mergometer
  module Reports
    class MergeTrendReportEntry
      attr_reader :date

      def initialize(date, prs)
        @date = date
        @prs = prs
      end

      def value
        Math.median prs.map(&:time_to_first_review)
      end

      private

        attr_reader :prs
    end
  end
end
