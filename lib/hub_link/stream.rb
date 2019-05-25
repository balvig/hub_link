require "hub_link/api/pull_request"
require "hub_link/batch"

module HubLink
  class Stream
    def initialize(repo, start_date: nil)
      @repo = repo
      @start_date = start_date&.to_date
    end

    def in_batches(&block)
      page = 1
      loop do
        batch = Batch.new(repo: repo, since: start_date, page: page)
        break if batch.empty?
        yield batch
        page += 1
      end
    end

    private

      attr_accessor :repo, :start_date
  end
end
