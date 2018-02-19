require "gruff"

module Mergometer
  module Reports
    class Graph
      def initialize(labels:)
        @graph = Gruff::Area.new(SIZE)
        #@graph.hide_dots = true
        @graph.marker_font_size = 10
        @graph.legend_font_size = 15
        #@graph.line_width = 2
        @graph.labels = labels
      end

      def data(legend, values)
        graph.data(legend, values)
      end

      def write(filename)
        graph.write(filename)
      end

      private

        SIZE = "1000x600"
        attr_reader :graph
    end
  end
end
