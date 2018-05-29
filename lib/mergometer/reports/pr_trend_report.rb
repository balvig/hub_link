module Mergometer
  module Reports
    class PrTrendReport < BaseReport
      METRICS = %i(approval_time time_to_first_review merge_time number_of_given_reviews).freeze

      private

        def first_column_name
          "Metric, time in hours"
        end

        def table_keys
          @table_keys ||= grouped_prs_by_time.keys.map(&:to_date)
        end

        def data_sets
          @data_sets ||= METRICS.map do |metric|
            ["average_#{metric}", grouped_prs_by_time.values.map do |prs|
              PrTrendReportEntry.new(prs.map(&metric)).average
            end]
          end.to_h
        end

        def prs
          @prs.reject do |pr|
            METRICS.any? do |metric|
              pr.public_send(metric).blank?
            end
          end
        end

        def add_total?
          false
        end
    end
  end
end
