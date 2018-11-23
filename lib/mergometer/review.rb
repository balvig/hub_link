module Mergometer
  class Review < SimpleDelegator
    BOTS = %w(houndci-bot cookpad-devel)

    def reviewer
      user.login
    end

    def approval?
      state == "APPROVED"
    end

    def invalid?
      bot? || driveby? || draft?
    end

    private

      def bot?
        BOTS.include?(user.login)
      end

      def driveby?
        state == "COMMENTED"
      end

      def draft?
        state == "PENDING"
      end
  end
end
