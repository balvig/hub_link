require "hub_link"
require "hub_link/callbacks"
require "hub_link/insert"

module HubLink
  class Importer
    delegate :callback, to: :callbacks

    def self.run(*args, &block)
      new(*args, &block).run
    end

    def initialize(repo:, start_date:, batch_size: 7, resources:, &block)
      @repo = repo.to_s
      @start_date = start_date
      @batch_size = batch_size
      @resources = resources
      @callbacks = Callbacks.new(block)
    end

    def run
      stream.in_batches do |batch|
        callback(:init, batch.query)

        resources.each do |source, target|
          callback(:start, source)
          import batch.fetch(source), to: target
          callback(:finish, target.count)
        end
      end
    end

    private

      attr_reader :repo, :start_date, :batch_size, :resources, :callbacks

      def import(records, to:)
        records.each do |row|
          Insert.new(row: row, target: to).run
        end
      end

      def stream
        @_stream ||= Stream.new(repo, start_date: start_date, batch_size: batch_size)
      end
  end
end
