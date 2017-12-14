require "mergometer/report"

module Mergometer
  class MergeTrendReport < Report
    private

    def fields
      %i(date median_merge_time)
    end

    def entries
      super.map do |pr|
        pr.group_by.created_at.to_date do |date, prs|
          MergeTrendReportEntry.new(date, prs)
        end
      end
    end

    def filter
      "repo:#{repo} type:pr is:merged created:>=#{24.weeks.ago.to_date}"
    end

    class MergeTrendReportEntry
      attr_reader :date

      def initialize(date, prs)
        @date = date
        @prs = prs
      end

      def median_merge_time
        Math.median prs.map(&:merge_time)
      end

      private

        attr_reader :prs
    end
  end
end
