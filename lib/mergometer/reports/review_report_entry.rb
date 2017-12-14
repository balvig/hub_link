module Mergometer
  module Reports
    class ReviewReportEntry
      attr_accessor :user, :reviews

      def initialize(user:, reviews:)
        @user = user
        @reviews = reviews
      end
    end
  end
end
