require "mergometer/reports/user_count_entry"

module Mergometer
  module Reports
    class Aggregate
      def initialize(countables:, users:)
        @countables = countables
        @users = users
      end

      # whoa.... sort out this mess
      def run(&block)
        countables.inject({}) do |result, countable|
          users.each do |user|
            result[user] ||= 0
            result[user] += 1 if yield(countable, user)
          end
          result
        end.map do |user, count|
          UserCountEntry.new(user: user, count: count)
        end
      end

      private

        attr_reader :countables, :users
    end
  end
end
