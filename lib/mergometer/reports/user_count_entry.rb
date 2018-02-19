module Mergometer
  module Reports
    class UserCountEntry
      attr_accessor :user, :count

      def initialize(user:, count:)
        @user = user
        @count = count
      end
    end
  end
end
