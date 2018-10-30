require "mergometer/core_ext/float"
require "mergometer/review"
require "mergometer/review_request"

module Mergometer
  class PullRequest < SimpleDelegator
    def self.search(filter)
      Octokit.search_issues(filter).items.map { |item| new(item) }
    end

    def submitter
      user.login
    end

    def reviewers
      @_reviewers ||= reviews.map(&:user).map(&:login).uniq
    end

    def reviews
      @_reviews ||= fetch_reviews
    end

    def review_requests
      @_review_requests ||= fetch_review_requests
    end

    # Metrics
    def additions
      extended_data.additions
    end

    def body_size
      body.to_s.size
    end

    def merge_time
      return unless merged?

      (closed_at - created_at).in_hours
    end

    def time_to_first_review
      return if first_review.blank?

      (first_review.submitted_at - created_at).in_hours
    end

    def approval_time
      return if first_approval.blank?

      (first_approval.submitted_at - created_at).in_hours
    end

    def straight_approval?
      reviews.all?(&:approval?)
    end

    def review_count
      reviews.size
    end

    private

      def merged?
        closed_at.present?
      end

      def fetch_review_requests
        requests = Octokit.pull_request_review_requests(repo, number)

        requests.users.compact.map do |user|
          ReviewRequest.new(created_at: created_at, user: user)
        end
      end

      def fetch_reviews
        Octokit.pull_request_reviews(repo, number).map do |data|
          data.pull_request_id = id
          Review.new(data)
        end.reject(&:invalid?)
      end

      def first_approval
        reviews.find(&:approval?)
      end

      def first_review
        reviews.first
      end

      def extended_data
        @_extended_data ||= Octokit.get(pull_request.url)
      end

      def repo
        extended_data.base.repo.full_name
      end
  end
end
