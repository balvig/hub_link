module Mergometer
  class MergeTimeReport < Report
    def render
      super
    end

    private

      def fields
        [:title, :additions, :time_to_first_review]
      end

      def filter
        "repo:#{repo} type:pr is:merged created:>=#{1.week.ago.to_date}"
      end
  end
end
