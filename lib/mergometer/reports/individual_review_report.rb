require "gruff"
require "mergometer/report"
require "mergometer/reports/review_aggregates"

module Mergometer
  module Reports
    class IndividualReviewReport < Report
      GROUPING = :week

      def render
        graph.labels = labels
        graph.hide_dots = true
        graph.marker_font_size = 10
        graph.legend_font_size = 15

        data_sets.each do |user, reviews|
          graph.data(user, reviews)
        end

        graph.write("individual_review_report.png")
      end

      private

        def graph
          @_graph ||= Gruff::Line.new("1000x600")
        end

        def filter
          [
            #"repo:#{repo} type:pr created:#{52.weeks.ago.to_date}..#{26.weeks.ago.to_date}",
            "repo:#{repo} type:pr created:>=#{26.weeks.ago.to_date}"
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
            result[user] = entries.map(&:reviews)
            result
          end
        end

        def grouped_entries
          @_grouped_entries ||= fetch_entries
        end

        def fetch_entries
          grouped_prs.inject({}) do |result, (time, prs)|
            result[time] = ReviewAggregates.new(prs, reviewers: all_reviewers).entries
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
