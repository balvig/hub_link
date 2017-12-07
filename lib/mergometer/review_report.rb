require "mergometer/review_ranking"

module Mergometer
  class ReviewReport < Report
    def render
      super
      puts "PRs awaiting review (#{prs_awaiting_review.size}): " + prs_awaiting_review.join(", ")
    end

    private


      def prs_awaiting_review
        prs.find_all(&:unreviewed?).map do |pr|
          "##{pr.number}"
        end
      end

      def fields
        [:user, :reviews]
      end

      def filter
        "repo:#{repo} type:pr updated:>=#{1.week.ago.to_date}"
      end

      def fields_to_preload
        %i(reviewers pr_data)
      end

      def entries
        rankings
      end

      def rankings
        review_data.map do |user, reviews|
          ReviewRanking.new(user: user, reviews: reviews)
        end
      end

      def review_data
        prs.inject({}) do |result, pr|
          pr.reviewers.each do |reviewer|
            result[reviewer] ||= 0
            result[reviewer] += 1
          end
          result
        end
      end
  end
end
