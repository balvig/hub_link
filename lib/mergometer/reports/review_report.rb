require "mergometer/report"
require "mergometer/reports/review_report_entry"

module Mergometer
  module Reports
    class ReviewReport < Report
      def render
        super
        puts "PRs awaiting review: #{prs_awaiting_review.size}"
        puts "https://github.com/cookpad/global-web/pulls?" + { q: awaiting_review_filter }.to_query
      end

      private

        def prs_awaiting_review
          @_prs_awaiting_review ||= PullRequest.search(awaiting_review_filter)
        end

        def awaiting_review_filter
          "repo:#{repo} is:pr is:open review:required NOT [WIP]"
        end

        def fields
          [:user, :reviews]
        end

        def filter
          "repo:#{repo} type:pr created:>=#{1.week.ago.to_date}"
        end

        def fields_to_preload
          %i(reviewers)
        end

        def entries
          review_data.map do |user, reviews|
            ReviewReportEntry.new(user: user, reviews: reviews)
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
end
