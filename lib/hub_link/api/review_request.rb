module HubLink
  module Api
    class ReviewRequest
      attr_reader :id, :reviewer, :requester, :created_at, :pull_request_id

      def initialize(id:, reviewer:, requester:, created_at:, pull_request_id:)
        @id = id
        @reviewer = reviewer
        @requester = requester
        @created_at = created_at
        @pull_request_id = pull_request_id
      end

      def to_h
        Slicer.new(self, columns: %i(id reviewer requester created_at pull_request_id)).to_h
      end
    end
  end
end
