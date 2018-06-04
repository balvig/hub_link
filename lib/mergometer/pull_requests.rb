require "Date"
require_relative "pull_requests_fetcher"

module Mergometer
  class PullRequests
    include Enumerable
    extend Forwardable
    extend Mergometer::PullRequestsFetcher

    def_delegators :@prs, :each, :[], :[]=, :last, :first, :size, :map, :reject, :select

    attr_reader :prs

    def initialize(prs)
      @prs = prs.map do |pr|
        get_pr_from_data(pr)
      end
    end

    def merge(pull_requests)
      push(*pull_requests.prs)
    end

    def add(pr)
      prs.push(get_pr_from_data(pr))
    end

    def push(*pulls)
      pulls.each do |pr|
        add(pr)
      end
    end

    def review_required_prs
      prs.select(&:review_required)
    end

    def merged_prs
      prs.select(&:merged?)
    end

    def total_pr_count
      size
    end

    def count
      size
    end

    def eligible_pr_count
      eligible_prs.size
    end

    def review_required_count
      prs.select(&:review_required?).size
    end

    def reviews_to_prs_count
      prs.map do |pr|
        pr.reviews.count
      end.reduce(:+)
    end

    def problem_ratio
      ((problematic_count / eligible_pr_count.to_f) * 100).round(2)
    end

    def quick_fix_ratio
      quick_fix_count / eligible_pr_count.to_f
    end

    def problematic_count
      prs.count(&:problematic?)
    end

    def quick_fix_count
      prs.count(&:quick_fix?)
    end

    def long_running_count
      prs.count(&:long_running?)
    end

    def heavily_commented_count
      prs.count(&:heavily_commented?)
    end

    def inactive?
      eligible_pr_count < 1
    end

    # Metrics

    def average_comment_count
      calculate_metric(:comment_count)
    end

    def average_merge_time
      calculate_metric(:merge_time)
    end

    def average_changes
      calculate_metric(:changes)
    end

    def average_approval_time
      calculate_metric(:approval_time)
    end

    def average_time_to_first_review
      calculate_metric(:time_to_first_review)
    end

    def average_number_of_given_reviews
      calculate_metric(:number_of_given_reviews)
    end

    private

      attr_writer :prs

      def get_pr_from_data(pr)
        if pr.is_a? PullRequest
          pr
        else
          PullRequest.new(pr)
        end
      end

      def calculate_metric(metric)
        Math.mean(eligible_prs.map(&metric).compact).round(2)
      end

      def eligible_prs
        prs.reject(&:quick_fix?)
      end
  end
end
