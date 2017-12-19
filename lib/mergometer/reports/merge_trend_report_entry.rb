module Mergometer
  module Reports
    class MergeTrendReportEntry
      attr_reader :date

      def initialize(date, prs)
        @date = date
        @prs = prs
      end

      def pr_count
        prs.size
      end

      def median_approval_time
        Math.median prs.map(&:approval_time)
      end

      private

        attr_reader :prs
    end
  end
end
