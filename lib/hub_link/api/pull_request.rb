module HubLink
  module Api
    class PullRequest < Issue
      require "hub_link/api/issue"
      require "hub_link/api/review"

      ADDITIONAL_EXPORT_COLUMNS = %i(
        merged_at
        body_size
        additions
        comments_count
        review_comments_count
      )

      def pull_request?
        true
      end

      def reviews
        @_reviews ||= fetch_reviews
      end

      def additions
        extended_data.additions
      end

      def body_size
        body.to_s.size
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

      private

        def export_columns
          super + ADDITIONAL_EXPORT_COLUMNS
        end

        def fetch_reviews
          Octokit.pull_request_reviews(repo, number).map do |data|
            data.repo = repo
            data.pull_request_id = id
            data.number = number
            data.submitter = submitter
            Review.new(data)
          end
        end

        def extended_data
          @_extended_data ||= Octokit.get(pull_request.url)
        end
    end
  end
end
