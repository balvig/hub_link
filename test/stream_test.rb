require 'test_helper'

module HubLink
  class StreamTest < Minitest::Test
    def test_finding_in_batches
      Stream.new("balvig/hub_link").in_batches do |batch|
        puts batch.pull_requests
      end
    end
  end
end
