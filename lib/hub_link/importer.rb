require "hub_link/insert"

module HubLink
  class Importer
    def self.run(*args)
      new(*args).run
    end

    def initialize(repo:, since:, resources:)
      @repo = repo.to_s
      @since = since
      @resources = resources
    end

    def run
      stream.in_batches do |batch|
        resources.each do |source, target|
          import batch.fetch(source), to: target
        end
      end
    end

    private

      attr_reader :repo, :since, :resources

      def stream
        @_stream ||= Stream.new(repo, since: since)
      end

      def import(records, to:)
        records.each do |row|
          Insert.new(row: row, target: to).run
        end
      end
  end
end
