require 'test_helper'

module HubLink::Api
  class PullRequestTest < Minitest::Test
    def test_finding_oldest_pr
      assert_equal "2018-04-23", PullRequest.oldest(repo: "balvig/hub_link").updated_at.to_date.to_s
    end

    def test_review_requests
      pr = PullRequest.search("type:pr 64 repo:cookpad/cp8").first

      review_request = pr.review_requests.first

      assert_equal "balvig", review_request.requester
      assert_equal "tapster", review_request.reviewer
    end

    def test_reviews
      pr = PullRequest.search("type:pr 12 repo:balvig/hub_link").first

      assert_equal "balvig", pr.reviews.first.user.login
    end
  end
end
