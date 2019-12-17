require 'test_helper'

module HubLink
  class StreamTest < Minitest::Test

    def test_streaming_reviews
      Stream.new("balvig/hub_link").in_batches do |batch|
        result = batch.reviews.first

        assert_equal 114238795, result[:id]
        # {
        # "id" => 114238795,
        # "pull_request_id" => 316653904,
        # "submitted_at" => "2018-04-23 04:05:11 UTC",
        # "reviewer" => "balvig",
        # "reply"=>false,
        # "state"=>"APPROVED",
        # "html_url"=> "https://github.com/balvig/hub_link/pull/1#pullrequestreview-114238795",
        # "body"=>"Nice, thanks!",
        # "review_comments_count"=>0
        # },
        # batch.reviews.first
      end
    end

    def test_streaming_pull_requests
      Stream.new("balvig/hub_link").in_batches do |batch|
        result = batch.pull_requests.first

        assert_equal 316653904, result[:id]
      end
    end

    def test_streaming_issues
      Stream.new("balvig/hub_link").in_batches do |batch|
        result = batch.issues.first

        assert_equal 332258376, result[:id]
      end
    end
  end
end
