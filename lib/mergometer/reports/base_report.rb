require "gruff"

module Mergometer
  module Reports
    class BaseReport
      def initialize(prs, **options)
        @prs = prs
        {
          name: default_name,
          group_by: :week,
          graph_type: "Line"
        }.each do |k, v|
          instance_variable_set("@#{k}", options[k] || v)
        end
      end

      def save_to_csv
        CSV.open("#{@name}.csv", "w") do |csv|
          csv << table_entries.first.keys if table_entries&.first&.keys
          table_entries.each do |hash|
            csv << hash.values
          end
        end

        p "#{@name} CSV exported."
      end

      def print_report
        p Hirb::Helpers::Table.render(
          table_entries,
          unicode: true,
          resize: false,
          description: false
        )
      end

      def to_h
        table_entries
      end

      def save_graph_to_image(type: @graph_type)
        g = Object.const_get("Gruff::#{type}").new
        g.title = @name
        g.labels = gruff_labels
        data_sets.each do |key, set|
          g.data key.to_sym, set
        end
        g.write("#{@name}.png")

        p "#{@name} PNG exported."
      end

      private

        attr_reader :prs

        def gruff_labels
          labels = {}
          table_keys.each_with_index do |v, i|
            labels[i] = v
          end
          labels
        end

        def default_name
          self.class.name.demodulize
        end

        def table_entries
          @table_entries ||= data_sets.map do |key, entries|
            ([first_column_name => key] + entries.each_with_index.map do |v, i|
              { table_keys[i] => v }
            end + ["Total" => sum[key]] + ["Average" => average[key]]).reduce({}, :merge)
          end.sort_by { |h| h["Average"] }.reverse
        end

        def grouped_entries_by_time_and_user
          @grouped_entries_by_time_and_user ||= grouped_prs_by(type: @group_by).inject({}) do |result, (time, prs)|
            result[time] = Reports::Aggregate.new(prs: prs, users: users).run do |pr, user|
              pr.user == user
            end
            result
          end
        end

        def grouped_entries_by_time_and_reviewer
          @grouped_entries_by_time_and_reviewer ||= grouped_prs_by(type: @group_by).inject({}) do |result, (time, prs)|
            result[time] = Reports::Aggregate.new(prs: prs, users: reviewers).run do |pr, user|
              pr.reviewers.include?(user)
            end
            result
          end
        end

        def grouped_prs_by(type: :week)
          @grouped_prs_by ||= prs.sort_by(&type).group_by(&type)
        end

        def grouped_prs_by_users
          @grouped_prs_by_users ||= prs.group_by(&:user)
        end

        def users
          @users ||= prs.group_by(&:user).keys
        end

        def reviewers
          @reviewers ||= prs.flat_map(&:reviewers).uniq
        end

        def first_column_name
          raise NotImplementedError
        end

        def table_keys
          raise NotImplementedError
        end

        def data_sets
          raise NotImplementedError
        end

        def average
          @average ||= data_sets.map do |k, v|
            [k, (v.reduce(:+) / v.size.to_f).round(2)]
          end.to_h
        end

        def sum
          @sum ||= data_sets.map do |k, v|
            [k, v.reduce(:+)]
          end.to_h
        end
    end
  end
end
