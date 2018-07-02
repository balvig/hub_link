require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class ReviewReport < Report
      def render
        puts "Reviews last week: #{range}"
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
          Aggregate.new(countables: filtered_reviews, users: reviewers_in_prs).run do |review, user|
            review.user.login == user
          end
        end

        def filtered_reviews
          reviews_in_prs.find_all do |review|
            range.cover?(review.submitted_at)
          end
        end

        def reviews_in_prs
          @_reviews_in_prs ||= prs.flat_map(&:reviews)
        end

        def range
          week.beginning_of_week...week.end_of_week
        end

        def week
          Date.today.last_week
        end

        def reviewers_in_prs
          filtered_reviews.flat_map(&:user).map(&:login).uniq
        end
    end
  end
end
