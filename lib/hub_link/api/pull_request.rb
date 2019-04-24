require "octokit"
require "hub_link/core_ext/float"
require "hub_link/api/review"
require "hub_link/api/review_request"
require "hub_link/slicer"

module HubLink
  module Api
    class PullRequest < SimpleDelegator
      def self.search(filter)
        Octokit.search_issues(filter).items.map { |item| new(item) }
      end

      def self.oldest(repo:)
        search("type:pr sort:updated-asc repo:#{repo}").first
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

      def repo
        extended_data.base.repo.full_name
      end

      def labels
        @_labels ||= Octokit.labels_for_issue(repo, number).map(&:name).join(", ")
      end

      def to_h
        Slicer.new(self, columns: %i(id number created_at updated_at closed_at approval_time time_to_first_review merge_time body_size additions review_count submitter straight_approval? labels repo)).to_h
      end

      private

        def merged?
          closed_at.present?
        end

        def fetch_review_requests
          requests = Octokit.pull_request_review_requests(repo, number)

          requests.users.compact.map do |reviewer|
            ReviewRequest.new(id: id, created_at: created_at, reviewer: reviewer.login, requester: submitter, pull_request_id: id)
          end
        end

        def fetch_reviews
          Octokit.pull_request_reviews(repo, number).map do |data|
            data.pull_request_id = id
            data.number = number
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
    end
  end
end
