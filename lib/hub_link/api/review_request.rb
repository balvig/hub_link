module HubLink
  module Api
    class ReviewRequest
      require "digest/sha1"

      attr_reader :reviewer, :requester, :created_at, :pull_request_id

      def initialize(reviewer:, requester:, created_at:, pull_request_id:)
        @reviewer = reviewer
        @requester = requester
        @created_at = created_at
        @pull_request_id = pull_request_id
      end

      # API doesn't return IDs for review requests https://developer.github.com/v3/pulls/review_requests/#list-review-requests
      def digest
        Digest::SHA1.hexdigest(digest_components.join)
      end

      def to_h
        Slicer.new(self, columns: %i(digest reviewer requester created_at pull_request_id)).to_h
      end

      private

        def digest_components
          [pull_request_id, reviewer]
        end
    end
  end
end
