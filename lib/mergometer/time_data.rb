module Mergometer
  class TimeData
    include Comparable

    attr_reader :seconds

    def initialize(seconds)
      @seconds = seconds
    end

    def to_s
      if blank?
        "-"
      else
        in_hours.to_s
      end
    end

    def blank?
      !seconds
    end

    def <=>(other)
      return unless other.is_a?(TimeData)
      seconds.to_i <=> other.seconds.to_i
    end

    private

      def in_hours
        (seconds / 60 / 60).round
      end
  end
end
