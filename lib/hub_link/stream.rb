require "hub_link/api/pull_request"
require "hub_link/batch"

module HubLink
  class Stream
    def initialize(repo, start_date: nil, batch_size: 7)
      @repo = repo
      @start_date = (start_date || date_of_first_pr).to_date
      @batch_size = batch_size
    end

    def in_batches(&block)
      start_date.step(end_date, batch_size) do |date|
        range = "#{date}..#{date + (batch_size - 1)}"
        yield Batch.new "type:pr updated:#{range} repo:#{repo}"
      end
    end

    private

      attr_accessor :repo, :start_date, :batch_size

      def date_of_first_pr
        Api::PullRequest.oldest(repo: repo)&.updated_at
      end

      def end_date
        @_end_date ||= Date.tomorrow
      end
  end
end
