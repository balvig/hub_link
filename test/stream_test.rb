require 'test_helper'

module HubLink
  class StreamTest < Minitest::Test
    def test_finding_in_batches
      require "pp"

      Stream.new("cookpad/streamy", since: 2.months.ago).in_batches do |batch|
        puts "\n\nReview Requests\n"
        pp batch.review_requests.first

        puts "\n\nReviews\n"
        pp batch.reviews.first

        puts "\n\nPull Requests\n"
        pp batch.pull_requests.first

        puts "\n\nIssues\n"
        pp batch.issues.first
      end
    end
  end
end
