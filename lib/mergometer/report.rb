require "progress_bar"
require "mergometer/pull_request"

module Mergometer
  class Report
    require "hirb"

    GROUPING = :week

    def initialize(repo, from = nil)
      @repo = repo
      @from = from || (Date.today - 1.day).beginning_of_week.strftime("%Y-%m-%d")
    end

    def run
      preload
      p grouped_prs_by_week.keys, from
    end

    private

      attr_accessor :repo, :from

      def render
        puts Hirb::Helpers::AutoTable.render(
          grouped_prs_by_week,
          unicode: true,
          fields: fields,
          description: false
        )

        puts "Total number of PRs checked: #{prs.size} (#{filter})"
      end

      def reversed_prs
        prs.reverse_each.map { |v| v }
      end

      def filter
        "base:master repo:#{repo} type:pr is:merged created:>=#{from}"
      end

      def fields_to_preload
        []
      end

      def prs
        @_prs ||= fetch_prs
      end

      def fetch_prs
        Array(filter).flat_map do |filter|
          PullRequest.search(filter)
        end
      end

      def grouped_prs_by_week
        @_grouped_prs_by_week ||= reversed_prs.sort_by(&GROUPING).group_by(&GROUPING)
      end

      def contributors
        @contributors ||= prs.group_by(&:user).keys
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
