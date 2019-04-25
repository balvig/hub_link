module HubLink
  module Api
    class Review < SimpleDelegator
      BOTS = %w(houndci-bot cookpad-devel)

      def reviewer
        user&.login
      end

      def approval?
        state == "APPROVED"
      end

      def invalid?
        bot? || driveby? || draft?
      end

      def to_h
        Slicer.new(self, columns: %i(id pull_request_id submitted_at reviewer approval?)).to_h
      end

      private

        def bot?
          BOTS.include?(reviewer)
        end

        def driveby?
          state == "COMMENTED"
        end

        def draft?
          state == "PENDING"
        end
    end
  end
end
