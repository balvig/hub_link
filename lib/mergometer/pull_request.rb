require "mergometer/core_ext/float"

module Mergometer
  class PullRequest
    QUICK_FIX_CUTOFF = 6 # Changes
    LONG_RUNNING_LENGTH = 5 * 24 * 60 * 60 # Days
    HEAVILY_COMMENTED_COUNT = 20 # Comments

    def initialize(data)
      @data = data
    end

    def title
      data.title
    end

    def number
      data.number
    end

    def user
      data.user.login
    end

    def week
      created_at.beginning_of_week
    end

    def month
      created_at.beginning_of_month
    end

    # Metrics

    def additions
      pr_data.additions
    end

    def problematic?
      heavily_commented?
    end

    def quick_fix?
      changes < QUICK_FIX_CUTOFF
    end

    def long_running?
      merge_time_in_seconds > LONG_RUNNING_LENGTH
    end

    def heavily_commented?
      comment_count > HEAVILY_COMMENTED_COUNT
    end

    def comment_count
      @_comment_count ||= data.comments + comment_data.size
    end

    def merge_time
      (data.closed_at - created_at).in_hours
    end

    def time_to_first_review
      (reviews.first.submitted_at - created_at).in_hours
    end

    def approval_time
      return if first_approval.blank?

      (first_approval.submitted_at - created_at).in_hours
    end

    def awaiting_review?
      !wip? && open? && reviewers.empty?
    end

    def reviewers
      @_reviewers ||= reviews.map(&:user).map(&:login).uniq
    end

    private

      attr_accessor :data

      def open?
        data.state == "open"
      end

      def wip?
        title.include?("[WIP]")
      end

      def created_at
        data.created_at
      end

      def reviews
        @_reviews ||= fetch_reviews
      end

      def fetch_reviews
        Octokit.pull_request_reviews(repo, number).reject do |review|
          review.user.login == "houndci-bot"
        end
      end

      def changes
        @_changes ||= pr_data.additions + pr_data.deletions
      end

      def first_approval
        reviews.find { |r| r.state == "APPROVED" }
      end

      def comment_data
        @_comment_data ||= Octokit.get(pr_data.review_comments_url)
      end

      def pr_data
        @_pr_data ||= Octokit.get(data.pull_request.url)
      end

      def repo
        pr_data.base.repo.full_name
      end
  end
end
