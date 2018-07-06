module Mergometer
  class Review < SimpleDelegator
    def submitter
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
        %w(houndci-bot cookpad-devel).include?(user.login)
      end

      def driveby?
        state == "COMMENTED"
      end

      def draft?
        state == "PENDING"
      end
  end
end
