module HubLink
  module Api
    class Review < SimpleDelegator
      EXPORT_COLUMNS = %i(
        id
        pull_request_id
        submitted_at
        reviewer
        reply?
        state
        html_url
        body
      )

      def reviewer
        user&.login
      end

      def reply?
        reviewer == submitter
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

        def submitted?
          !draft?
        end

        def draft?
          state == "PENDING"
        end
    end
  end
end
