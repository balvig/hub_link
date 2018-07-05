require "progress_bar"
require "mergometer/pull_request"

module Mergometer
  class Report
    require "hirb"

    def initialize(repo)
      @repo = repo
    end

    def run
      preload
      render
    end

    private

      attr_accessor :repo

      def render
        render_table
      end

      def render_table
        puts Hirb::Helpers::AutoTable.render(
          sorted_entries,
          unicode: true,
          fields: fields,
          description: false
        )
      end

      def fields
        raise "Implement fields method"
      end

      def sort_field
        fields.last
      end

      def sorted_entries
        entries.sort_by(&sort_field).reverse
      end

      def entries
        prs
      end

      def filter
        "base:master #{repo_query} type:pr is:merged"
      end

      def fields_to_preload
        []
      end

      def repo_query
        @_repo_query = repo.split(",").map do |r|
          "repo:#{r}"
        end.join(" ")
      end

      def prs
        @_prs ||= fetch_prs
      end

      def fetch_prs
        Array(filter).flat_map do |filter|
          puts "Retrieving: #{filter}"
          PullRequest.search(filter)
        end
      end

      def preload
        prs.each do |pr|
          fields_to_preload.each do |field|
            pr.send(field)
          end
          progress_bar.increment!
        end
      end

      def progress_bar
        @_progress_bar ||= ProgressBar.new(prs.size, :bar, :counter, :elapsed)
      end
  end
end
