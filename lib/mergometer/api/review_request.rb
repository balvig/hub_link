module Mergometer
  module Api
    class ReviewRequest
      attr_reader :created_at, :user, :id

      def initialize(id:, created_at:, user:)
        @id = id
        @created_at = created_at
        @user = user
      end

      def reviewer
        user.login
      end
    end
  end
end
