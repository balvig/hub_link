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
        bot?
      end

      def to_h
        Slicer.new(self, columns: %i(id pull_request_id submitted_at reviewer approval? state)).to_h
      end

      private

        def bot?
          BOTS.include?(reviewer)
        end
    end
  end
end
