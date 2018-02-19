require "mergometer/report"
require "mergometer/reports/graph"
require "mergometer/reports/review_aggregates"

module Mergometer
  module Reports
    class IndividualReviewReport < Report
      GROUPING = :week
      REVIEWERS = %w(balvig kinopyo guilleiguaran sikachu davidstosik sebasoga)
      # REVIEWERS = %w(firewalker06 knack karlentwistle aqeelvn eqbal tapster l15n)

      def render
        data_sets.each do |user, values|
          graph.data(user, values)
        end

        graph.write("individual_review_report.png")
      end

      private

        def graph
          @_graph ||= Graph.new(labels: labels)
        end

        def filter
          [
            "repo:#{repo} type:pr created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "repo:#{repo} type:pr created:#{26.weeks.ago.to_date}..#{1.week.ago.to_date}"
          ]
        end

        def fields_to_preload
          %i(reviewers)
        end

        def labels
          grouped_entries.keys.each_with_index.inject({}) do |result, (time, index)|
            if index % 4 == 0
              result[index] = time.to_date
            end

            result
          end
        end

        def data_sets
          grouped_entries.values.flatten.group_by(&:user).inject({}) do |result, (user, entries)|
            result[user] = entries.map(&:count)
            result
          end
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
