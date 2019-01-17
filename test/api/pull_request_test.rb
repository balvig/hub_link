require 'test_helper'

module HubLink::Api
  class PullRequestTest < Minitest::Test
    def test_finding_oldest_pr
      assert_equal "2018-04-23", PullRequest.oldest(repo: "balvig/hub_link").updated_at.to_date.to_s
    end
  end
end
