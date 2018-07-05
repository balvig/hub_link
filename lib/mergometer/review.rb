module Mergometer
  class Review < SimpleDelegator
    def week
      submitted_at.beginning_of_week
    end

    def approval?
      state == "APPROVED"
    end

    def invalid?
      bot? || driveby? || draft?
    end

    private

      def bot?
        user.login == "houndci-bot"
      end

      def driveby?
        state == "COMMENTED"
      end

      def draft?
        state == "PENDING"
      end
  end
end