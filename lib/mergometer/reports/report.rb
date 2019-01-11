require "csv"
require "mergometer/slicer"

module Mergometer
  module Reports
    class Report
      def initialize(queries:, columns:)
        @queries = queries
        @columns = columns
      end

      def in_batches(&block)
        queries.each do |query|
          results = fetch_results(query).map do |record|
            Slicer.new(record, columns: columns).to_h
          end

          yield results
        end
      end

      private

        attr_reader :queries, :columns

        def fetch_results(query)
          Api::PullRequest.search(query)
        end
    end
  end
end
