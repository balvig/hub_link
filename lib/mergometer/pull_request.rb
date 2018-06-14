module Mergometer
  class PullRequest
    QUICK_FIX_CUTOFF = 6 # Changes
    LONG_RUNNING_LENGTH = 5 * 24 # Days
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

    def day
      created_at.beginning_of_day
    end

    def week
      created_at.beginning_of_week
    end

    def month
      created_at.beginning_of_month
    end

    def quarter
      created_at.beginning_of_quarter
    end

    def year
      created_at.beginning_of_year
    end

    # Metrics

    def additions
      extended_data.additions
    end

    def body_size
      data.body.to_s.size
    end

    def problematic?
      heavily_commented?
    end

    def quick_fix?
      changes < QUICK_FIX_CUTOFF
    end

    def long_running?
      merge_time > LONG_RUNNING_LENGTH
    end

    def heavily_commented?
      comment_count > HEAVILY_COMMENTED_COUNT
    end

    def comment_count
      @comment_count ||= data.comments + comment_data.size
    end

    def merge_time
      return if data.closed_at.blank?

      (data.closed_at - created_at).in_hours
    end

    def time_to_first_review
      return if first_review.blank?

      (first_review.submitted_at - created_at).in_hours
    end

    def approval_time
      return if first_approval.blank?

      (first_approval.submitted_at - created_at).in_hours
    end

    def review_required?
      number_of_given_reviews == 0 && open? && !wip?
    end

    def number_of_given_reviews
      reviewers.size
    end

    def reviewers
      @reviewers ||= reviews.map(&:user).map(&:login).uniq
    end

    def reviews
      @reviews ||= fetch_reviews
    end

    def open?
      data.state == "open"
    end

    def merged?
      data.state == "closed" && data.merged_at != "nil"
    end

    def wip?
      title.include?("[WIP]")
    end

    def changes
      @changes ||= extended_data.additions + extended_data.deletions
    end

    private

      attr_accessor :data

      def updated_at
        data.updated_at
      end

      def created_at
        data.created_at
      end

      def fetch_reviews
        Octokit.pull_request_reviews(repo, number).reject do |review|
          review.user.login.end_with?("bot", "[bot]")
        end
      end

      def first_approval
        reviews.find { |r| r.state == "APPROVED" }
      end

      def first_review
        reviews.first
      end

      def comment_data
        @comment_data ||= Octokit.get(extended_data.review_comments_url)
      end

      def extended_data
        @extended_data ||= Octokit.get(data.pull_request.url)
      end

      def repo
        extended_data.base.repo.full_name
      end
  end
end
