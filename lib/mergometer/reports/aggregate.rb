module Mergometer
  module Reports
    class Aggregate
      def initialize(prs:, users:)
        @prs = prs
        @users = users
      end

      def run(&block)
        prs.inject({}) do |result, pr|
          users.each do |user|
            result[user] ||= OpenStruct.new(prs: [], count: 0)
            if yield(pr, user)
              result[user].prs.push(pr)
              result[user].count += 1
            end
          end
          result
        end
      end

      private

        attr_reader :prs, :users
    end
  end
end
