require "mergometer/report"
require "mergometer/reports/aggregate"

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
          "#{repo_query} is:pr is:open review:required NOT [WIP]"
        end

        def fields
          %i(user count)
        end

        def filter
          "#{repo_query} type:pr updated:>=#{1.week.ago.to_date}"
        end

        def fields_to_preload
          %i(reviewers)
        end

        def entries
          Aggregate.new(prs: prs, users: reviewers_in_prs).run do |pr, user|
            pr.reviewers.include?(user)
          end
        end

        def reviewers_in_prs
          prs.flat_map(&:reviewers).uniq
        end
    end
  end
end
