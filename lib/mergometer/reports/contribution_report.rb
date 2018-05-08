require "csv"
require "mergometer/report"
require "mergometer/reports/aggregate"

module Mergometer
  module Reports
    class ContributionReport < Report
      GROUPING = :week

      def render
        CSV.open("contribution_report.csv", "w") do |csv|
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

        def data_sets
          grouped_entries.values.flatten.group_by(&:user)
        end

        def grouped_entries
          @_grouped_entries ||= fetch_entries
        end

        def fetch_entries
          grouped_prs.inject({}) do |result, (time, prs)|
            result[time] = Aggregate.new(prs: prs, users: contributors).run do |pr, user|
              pr.user == user
            end
          result
          end
        end

        def contributors
          @_contributors ||= prs.map(&:user).uniq
        end

        def grouped_prs
          @_grouped_prs ||= prs.sort_by(&GROUPING).group_by(&GROUPING)
        end
    end
  end
end
