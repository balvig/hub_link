require "csv"
require "progress_bar"
require "mergometer/pull_request"

module Mergometer
  class Report
    def initialize(repo:, query:, columns:, &block)
      @repo = repo
      @query = query
      @columns = columns
      @source = yield(prs)
    end

    def run
      export_csv
      puts "#{csv_file_name} exported."
    end

    private

      attr_accessor :repo, :query, :columns, :source

      def progress_bar
        @_progress_bar ||= ProgressBar.new(source.size, :bar, :counter, :elapsed)
      end

      def export_csv
        CSV.open(csv_file_name, "w", write_headers: true, headers: columns) do |csv|
          csv_data.each do |data|
            csv << data
          end
        end
      end

      def csv_file_name
        self.class.to_s.demodulize.underscore + ".csv"
      end

      def csv_data
        source.map do |record|
          progress_bar.increment!

          columns.map do |column|
            record.public_send(column)
          end
        end
      end

      def prs
        @_prs ||= fetch_prs
      end

      def fetch_prs
        Array(query).flat_map do |query|
          query_with_repo = "#{query} #{repo_query}"
          puts "Retrieving: #{query_with_repo}"
          PullRequest.search(query_with_repo)
        end
      end

      def repo_query
        @_repo_query = repo.split(",").map do |r|
          "repo:#{r}"
        end.join(" ")
      end
  end
end
