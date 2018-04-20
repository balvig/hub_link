require "hirb"
require "progress_bar"
require "mergometer/pull_request"

reports_path = File.expand_path("../reports/**/*.rb", __FILE__)
Dir[reports_path].each { |f| require f }

module Mergometer
  class Report
    GROUPING = :week
    METRICS = %i[user reviewers approval_time time_to_first_review merge_time quick_fix? comment_count additions heavily_commented? number_of_given_reviews].freeze

    def initialize(repo, from = nil)
      @repo = repo
      @from = from || (Date.today - 1.day).beginning_of_week.strftime("%Y-%m-%d")
      preload
      render
    end

    def user_pr_contribution
      Mergometer::Reports::ContributionReport.new(grouped_prs_by_week, contributors)
    end

    def user_review_contribution
      Mergometer::Reports::IndividualReviewReport.new(grouped_prs_by_week, reviewers)
    end

    private

      attr_accessor :repo, :from

      def render
        puts "Total number of PRs fetched: #{prs.size} (#{filter})"
      end

      def reversed_prs
        prs.reverse_each.map { |v| v }
      end

      def filter
        "base:master repo:#{repo} type:pr is:merged created:>=#{from}"
      end

      def fields_to_preload
        METRICS
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
        @_contributors ||= prs.group_by(&:user).keys
      end

      def reviewers
        @_reviewers ||= prs.flat_map(&:reviewers).uniq
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
