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
      data.created_at.beginning_of_week
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
      return if merge_time_in_seconds.blank?
      (merge_time_in_seconds / 60 / 60).round
    end

    def time_to_first_review
      return if time_to_first_review_in_seconds.blank?
      (time_to_first_review_in_seconds / 60 / 60).round
    end

    def unreviewed?
      open? && reviewers.empty?
    end

    def open?
      data.state == "open"
    end

    def reviewers
      @_reviewers ||= reviews.map(&:user).map(&:login).uniq
    end

    private

    attr_accessor :data

    def reviews
      Octokit.pull_request_reviews(repo, number).reject do |review|
        review.user.login == "houndci-bot"
      end
    end

    def changes
      @_changes ||= pr_data.additions + pr_data.deletions
    end

    def time_to_first_review_in_seconds
      return if reviews.empty?
      reviews.first.submitted_at - data.created_at
    end

    def merge_time_in_seconds
      data.closed_at - data.created_at
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
