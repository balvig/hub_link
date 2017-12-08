require "gruff"

module Mergometer
  class MergeTimeReport < Report
    def render
      preload
      %i(time_to_first_review).each do |field|
        y_axis = entries.map(&:additions)
        x_axis = entries.map(&field)
        graph.data(field, x_axis, y_axis)
      end
      graph.write("/www/images/dot.png")
    end

    private

    def graph
      @_graph ||= Gruff::Scatter.new(800)
    end

    def entries
      super.reject do |pr|
        pr.time_to_first_review.blank? || pr.additions > 10000 || pr.time_to_first_review > 200
      end
    end

    def filter
      "repo:#{repo} type:pr is:merged created:>=#{24.weeks.ago.to_date}"
    end
  end
end
