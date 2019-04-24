require 'test_helper'

module HubLink
  class StreamTest < Minitest::Test
    def test_finding_in_batches
      Stream.new("cookpad/streamy", start_date: 1.week.ago).in_batches do |batch|
        # puts batch.pull_requests
        # puts batch.reviews
        # puts batch.review_requests
      end
    end
  end
end
