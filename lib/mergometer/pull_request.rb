require "mergometer/core_ext/float"
require "mergometer/review"

module Mergometer
  class PullRequest < SimpleDelegator
    def self.search(filter)
      Octokit.search_issues(filter).items.map { |item| new(item) }
    end

    def user
      super.login
    end

    def week
      created_at.beginning_of_week
    end

    def month
      created_at.beginning_of_month
    end

    # Metrics
    def additions
      extended_data.additions
    end

    def body_size
      body.to_s.size
    end

    def merge_time
      return if closed_at.blank?

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

    def reviewers
      @_reviewers ||= reviews.map(&:user).map(&:login).uniq
    end

    def reviews
      @_reviews ||= fetch_reviews
    end

    private

      def fetch_reviews
        Octokit.pull_request_reviews(repo, number).map do |data|
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
        @_extended_data ||= Octokit.get(data.pull_request.url)
      end

      def repo
        extended_data.base.repo.full_name
      end
  end
end
