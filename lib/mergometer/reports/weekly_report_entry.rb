module Mergometer
  module Reports
    class WeeklyReportEntry

      attr_accessor :week

      def initialize(week:, prs:)
        @week = week
        @prs = prs
      end

      def count
        prs.size
      end

      private

        attr_accessor :prs
    end
  end
end
