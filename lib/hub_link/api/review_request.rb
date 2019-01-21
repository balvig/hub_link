module HubLink
  module Api
    class ReviewRequest
      attr_reader :id, :reviewer, :requester, :created_at

      def initialize(id:, reviewer:, requester:, created_at:)
        @id = id
        @reviewer = reviewer
        @requester = requester
        @created_at = created_at
      end

      def to_h
        Slicer.new(self, columns: %i(id reviewer requester created_at)).to_h
      end
    end
  end
end
