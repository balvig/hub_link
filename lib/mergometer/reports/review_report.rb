require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class ReviewReport < Report
      def render
        puts "Reviews last week of #{week}"
        super
      end

      private

        def fields
          %i(user count)
        end

        def filter
          # Assuming that getting PRs from 4 weeks ago should be enough
          "#{repo_query} type:pr created:>=#{4.weeks.ago.to_date}"
        end

        def fields_to_preload
          %i(reviews)
        end

        def entries
          Aggregate.new(countables: filtered_reviews, users: all_reviewers).run do |review, user|
            review.user.login == user
          end
        end

        def filtered_reviews
          reviews_in_prs.find_all do |review|
            review.week == week
          end
        end

        def reviews_in_prs
          @_reviews_in_prs ||= prs.flat_map(&:reviews)
        end

        def week
          Date.today.last_week
        end

        def all_reviewers
          filtered_reviews.flat_map(&:user).map(&:login).uniq
        end
    end
  end
end
