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
          grouped_prs.inject({}) do |result, (time, prs)|
            result[time] = Aggregate.new(prs: prs, users: all_reviewers).run do |pr, user|
              pr.reviewers.include?(user)
            end
            result
          end
        end

        def all_reviewers
          @_all_reviewers ||= prs.flat_map(&:reviewers).uniq
        end

        def grouped_prs
          @_grouped_prs ||= prs.sort_by(&GROUPING).group_by(&GROUPING)
        end
    end
  end
end
