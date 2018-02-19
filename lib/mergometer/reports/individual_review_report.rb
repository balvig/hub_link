require "csv"
require "mergometer/report"
require "mergometer/reports/review_aggregates"

module Mergometer
  module Reports
    class IndividualReviewReport < Report
      GROUPING = :week
      REVIEWERS = %w(balvig kinopyo guilleiguaran sikachu davidstosik sebasoga) +
        %w(firewalker06 Knack karlentwistle aqeelvn eqbal JuanitoFatas tapster l15n) +
        %w(rikarumi mshka)

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
            "repo:#{repo} type:pr created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "repo:#{repo} type:pr created:#{26.weeks.ago.to_date}..#{1.week.ago.to_date}"
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
          grouped_prs.inject({}) do |result, (time, prs)|
            result[time] = ReviewAggregates.new(prs, reviewers: REVIEWERS).entries
            result
          end
        end

        def grouped_prs
          @_grouped_prs ||= prs.sort_by(&GROUPING).group_by(&GROUPING)
        end
    end
  end
end
