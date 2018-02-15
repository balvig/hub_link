require "mergometer/reports/review_report_entry"

module Mergometer
  module Reports
    class ReviewAggregates
      def initialize(prs, reviewers: reviewers_in_batch)
        @prs = prs
        @reviewers = reviewers
      end

      def entries
        aggregated_reviews.map do |user, reviews|
          ReviewReportEntry.new(user: user, reviews: reviews)
        end
      end

      private

        attr_reader :prs, :reviewers

        def reviewers_in_batch
          prs.flat_map(&:reviewers).uniq
        end

        def aggregated_reviews
          prs.inject({}) do |result, pr|
            reviewers.each do |reviewer|
              result[reviewer] ||= 0
              result[reviewer] += 1 if pr.reviewers.include?(reviewer)
            end
            result
          end
        end
    end
  end
end
