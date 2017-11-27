module Mergometer
  class ReviewRanking
    attr_accessor :user, :reviews

    def initialize(user:, reviews:)
      @user = user
      @reviews = reviews
    end
  end
end
