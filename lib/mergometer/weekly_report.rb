require "mergometer/report"
require "mergometer/weekly_entry"

module Mergometer
  class WeeklyReport < Report
    def render
      super
      puts "Median num of PRs/week: #{median}"
    end

    private

      def fields
        %i(week count)
      end

      def entries
        @_entries ||= build_entries
      end

      def filter
        "repo:#{repo} type:pr created:<=#{Time.current.last_week.end_of_week.to_date}"
      end

      def build_entries
        prs.group_by(&:week).map do |week, weekly_prs|
          WeeklyEntry.new(week: week, prs: weekly_prs)
        end
      end

      def median
        Math.median entries.map(&:count)
      end
  end
end
