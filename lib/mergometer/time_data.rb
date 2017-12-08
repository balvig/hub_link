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

    def to_i
      in_hours.to_i
    end

    def to_f
      in_hours.to_f
    end

    def blank?
      !seconds
    end

    def <=>(other)
      return unless other.respond_to?(:to_i)
      to_i <=> other.to_i
    end

    private

      def in_hours
        (seconds / 60 / 60).round
      end
  end
end
