require "hub_link/api/pull_request"
require "hub_link/batch"

module HubLink
  class Stream
    GITHUB_BATCH_SIZE = 7 # Days

    def initialize(repo, start_date: nil)
      @repo = repo
      @start_date = (start_date || date_of_first_pr).to_date
    end

    def in_batches(&block)
      queries.each do |query|
        yield Batch.new(query)
      end
    end

    private

      attr_accessor :repo, :start_date

      def date_of_first_pr
        Api::PullRequest.oldest(repo: repo)&.updated_at
      end

      def queries
        start_date.step(end_date, GITHUB_BATCH_SIZE).map do |date|
          "type:pr updated:#{date}..#{date + GITHUB_BATCH_SIZE} repo:#{repo}"
        end
      end

      def end_date
        Date.tomorrow
      end
  end
end
