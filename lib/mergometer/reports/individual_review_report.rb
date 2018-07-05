require "csv"
require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class IndividualReviewReport < Report
      GITHUB_API_CHUNK = 14

      def render
        CSV.open("individual_review_report.csv", "w", write_headers: true, headers: %w(Date Reviewer)) do |csv|
          reviews_in_prs.each do |review|
            csv << [review.submitted_at, review.user.login]
          end
        end

        puts "CSV exported."
      end

      private

        def filter
          start_date.step(end_date, GITHUB_API_CHUNK).map do |date|
            "#{repo_query} type:pr created:#{date}..#{date + GITHUB_API_CHUNK}"
          end
        end

        def start_date
          52.weeks.ago.to_date
        end

        def end_date
          1.week.ago.to_date
        end

        def fields_to_preload
          %i(reviewers)
        end

        def reviews_in_prs
          @_reviews_in_prs ||= prs.flat_map(&:reviews)
        end
    end
  end
end
