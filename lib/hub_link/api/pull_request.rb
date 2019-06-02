require "octokit"
require "hub_link/core_ext/float"
require "hub_link/api/review"
require "hub_link/api/review_request"
require "hub_link/slicer"

module HubLink
  module Api
    class PullRequest < SimpleDelegator
      EXPORT_COLUMNS = %i(
        id
        title
        number
        created_at
        updated_at
        closed_at
        merged_at
        approval_time
        time_to_first_review
        merge_time
        body_size
        additions
        comments_count
        review_comments_count
        submitter
        straight_approval?
        labels
        repo
        html_url
        state
      )

      def self.list(repo:, page:, **options)
        Octokit.list_issues(repo, options.merge(page: page, sort: "updated", direction: "asc", state: "all")).map do |item|
          item.repo = repo
          new(item)
        end.find_all(&:pull_request?)
      end

      def pull_request?
        respond_to?(:pull_request)
      end

      def submitter
        user.login
      end

      def reviews
        @_reviews ||= fetch_reviews
      end

      def review_requests
        @_review_requests ||= fetch_review_requests
      end

      def additions
        extended_data.additions
      end

      def body_size
        body.to_s.size
      end

      def merge_time
        return unless merged?

        (merged_at - created_at).in_hours
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

      def merged_at
        extended_data.merged_at
      end

      def comments_count
        extended_data.comments
      end

      def review_comments_count
        extended_data.review_comments
      end

      def labels
        super.map(&:name).join(", ")
      end

      def to_h
        Slicer.new(self, columns: EXPORT_COLUMNS).to_h
      end

      private

        def merged?
          merged_at.present?
        end

        def fetch_review_requests
          requests = Octokit.pull_request_review_requests(repo, number)

          requests.users.compact.map do |reviewer|
            ReviewRequest.new(created_at: created_at, reviewer: reviewer.login, requester: submitter, pull_request_id: id)
          end
        end

        def fetch_reviews
          Octokit.pull_request_reviews(repo, number).map do |data|
            data.pull_request_id = id
            data.number = number
            data.submitter = submitter
            Review.new(data)
          end
        end

        def first_approval
          reviews.find(&:approval?)
        end

        def first_review
          reviews.find(&:submitted?)
        end

        def extended_data
          @_extended_data ||= Octokit.get(pull_request.url)
        end
    end
  end
end
