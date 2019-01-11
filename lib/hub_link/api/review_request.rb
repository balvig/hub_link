module HubLink
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

      def to_h
        Slicer.new(self, columns: %i(id user created_at reviewer)).to_h
      end
    end
  end
end
