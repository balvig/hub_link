require "mergometer/reports/user_count_entry"

module Mergometer
  module Reports
    class Aggregate
      def initialize(prs:, users:)
        @prs = prs
        @users = users
      end

      # whoa.... sort out this mess
      def run(&block)
        prs.inject({}) do |result, pr|
          users.each do |user|
            result[user] ||= 0
            result[user] += 1 if yield(pr, user)
          end
          result
        end.map do |user, count|
          UserCountEntry.new(user: user, count: count)
        end
      end

      private

        attr_reader :prs, :users
    end
  end
end
