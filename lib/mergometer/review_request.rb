module Mergometer
  class ReviewRequest
    attr_reader :created_at, :user

    def initialize(created_at:, user:)
      @created_at = created_at
      @user = user
    end

    def reviewer
      user.login
    end
  end
end
