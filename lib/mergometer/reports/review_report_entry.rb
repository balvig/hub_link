module Mergometer
  module Reports
    class ReviewReportEntry
      attr_accessor :user, :count

      def initialize(user:, count:, total:)
        @user = user
        @count = count
        @total = total
      end

      def percentage
        ((count / total.to_f) * 100).round
      end

      private

        attr_reader :total
    end
  end
end
