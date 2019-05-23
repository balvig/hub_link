module HubLink
  module Api
    class Review < SimpleDelegator
      EXPORT_COLUMNS = %i(
        id
        pull_request_id
        submitted_at
        reviewer
        approval?
        state
        html_url
      )

      def reviewer
        user&.login
      end

      def approval?
        state == "APPROVED"
      end

      def submitted?
        !draft?
      end

      def submitted_at
        if submitted?
          super
        end
      end

      def to_h
        Slicer.new(self, columns: EXPORT_COLUMNS).to_h
      end

      private

        def draft?
          state == "PENDING"
        end
    end
  end
end
