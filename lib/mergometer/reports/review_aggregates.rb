require "mergometer/reports/review_report_entry"

module Mergometer
  module Reports
    class ReviewAggregates
      def initialize(prs, reviewers: nil)
        @prs = prs
        @reviewers = reviewers
      end

      def entries
        aggregated_reviews.map do |user, reviews|
          ReviewReportEntry.new(user: user, count: reviews, total: total_reviews_given)
        end
      end

      private

        attr_reader :prs, :reviewers

        def reviewers
          @reviewers || reviewers_in_batch
        end

        def reviewers_in_batch
          prs.flat_map(&:reviewers).uniq
        end

        def aggregated_reviews
          @_aggregated_reviews ||= count_reviews
        end

        def count_reviews
          prs.inject({}) do |result, pr|
            reviewers.each do |reviewer|
              result[reviewer] ||= 0
              result[reviewer] += 1 if pr.reviewers.include?(reviewer)
            end
            result
          end
        end

        def total_reviews_given
          @_total_reviews_given ||= aggregated_reviews.values.sum
        end
    end
  end
end
