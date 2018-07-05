require "csv"
require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class IndividualReviewReport < Report
      GROUPING = :week

      def render
        CSV.open("individual_review_report.csv", "w") do |csv|
          csv << [nil] + grouped_entries.keys.map(&:to_date)
          data_sets.each do |user, entries|
            csv << [user] + entries.map(&:count)
          end
        end

        puts "CSV exported."
      end

      private

        def filter
          [
            "#{repo_query} type:pr created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "#{repo_query} type:pr created:#{26.weeks.ago.to_date}..#{1.week.ago.to_date}"
          ]
        end

        def fields_to_preload
          %i(reviewers)
        end

        def data_sets
          grouped_entries.values.flatten.group_by(&:user)
        end

        def grouped_entries
          @_grouped_entries ||= fetch_entries
        end

        def fetch_entries
          grouped_reviews.inject({}) do |result, (time, reviews)|
            result[time] = Aggregate.new(countables: reviews, users: all_reviewers).run do |review, user|
              review.user.login == user
            end
            result
          end
        end

        def reviews_in_prs
          @_reviews_in_prs ||= prs.flat_map(&:reviews)
        end

        def all_reviewers
          reviews_in_prs.flat_map(&:user).map(&:login).uniq
        end

        def grouped_reviews
          @_grouped_reviews ||= reviews_in_prs.sort_by(&GROUPING).group_by(&GROUPING)
        end
    end
  end
end
