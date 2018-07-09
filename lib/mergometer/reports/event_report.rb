require "mergometer/report"
require "ostruct"

module Mergometer
  module Reports
    class EventReport < Report
      def initialize(*args)
        super(
          columns: %w(created_at name),
          source: events
        )
      end

      private

        def events
          [
            OpenStruct.new(created_at: Date.parse("November 14th, 2017"), name: "Core / Committers"),
            OpenStruct.new(created_at: Date.parse("January 26th, 2017"), name: "Realtime reviews"),
            OpenStruct.new(created_at: Date.parse("April 24th, 2017"), name: "Pick reviewers")
          ]
        end
    end
  end
end
