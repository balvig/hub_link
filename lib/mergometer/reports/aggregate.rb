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
            result[user] ||= []
            if yield(pr, user)
              result[user].push(pr)
            end
          end
          result
        end.map do |user, prs|
          [user, OpenStruct.new(prs: prs, count: prs.count)]
        end.to_h
      end

      private

        attr_reader :prs, :users
    end
  end
end
