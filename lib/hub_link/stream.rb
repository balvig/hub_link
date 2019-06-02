require "hub_link/api/pull_request"
require "hub_link/batch"

module HubLink
  class Stream
    def initialize(repo, since: nil)
      @repo = repo
      @since = since&.to_date
    end

    def in_batches(&block)
      page = 1
      loop do
        batch = Batch.new(repo: repo, since: since, page: page)
        break if batch.empty?
        yield batch
        page += 1
      end
    end

    private

      attr_accessor :repo, :since
  end
end
