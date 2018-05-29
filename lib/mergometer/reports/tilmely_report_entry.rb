module Mergometer
  module Reports
    class TimelyReportEntry
      def initialize(prs:)
        @prs = prs
      end

      def count
        prs.size
      end

      private

        attr_reader :prs
    end
  end
end
