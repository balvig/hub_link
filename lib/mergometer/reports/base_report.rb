require "csv"
require "hirb"
require "gruff"
require "progress_bar"

module Mergometer
  module Reports
    class BaseReport
      def initialize(prs, **options)
        @prs = prs
        {
          name: default_name,
          group_by: "week",
          graph_type: "Line",
          show_total: true,
          show_average: true,
          load_reviews: false
        }.each do |k, v|
          if options[k].nil?
            instance_variable_set("@#{k}", v)
          else
            instance_variable_set("@#{k}", options[k])
          end
        end
        load_reviews if @load_reviews
      end

      def save_to_csv
        CSV.open("#{@name}.csv", "w") do |csv|
          csv << table_entries.first.keys if table_entries&.first&.keys
          table_entries.each do |hash|
            csv << hash.values
          end
        end

        puts "#{@name} CSV exported."
      end

      def print_report
        puts @name
        puts Hirb::Helpers::AutoTable.render(
          table_entries,
          unicode: true,
          fields: table_fields,
          resize: false,
          description: false
        )
      end

      def to_h
        table_entries
      end

      def save_graph(type: @graph_type)
        g = Object.const_get("Gruff::#{type}").new
        g.title = @name
        g.labels = gruff_labels
        data_sets.each do |key, set|
          g.data key.to_sym, set
        end
        g.write("#{@name}.png")

        puts "#{@name} PNG exported."
      end

      private

        def table_fields
          @table_fields = [first_column_name] + table_keys
          @table_fields.push("Total") if show_total?
          @table_fields.push("Average") if show_average?
          @table_fields
        end

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
            new_entry = ([first_column_name => key] + entries.each_with_index.map do |v, i|
              { table_keys[i] => v }
            end)
            new_entry.push("Total" => sum[key]) if show_total?
            new_entry.push("Average" => average[key]) if show_average?
            new_entry.reduce({}, :merge)
          end
          if show_average?
            @table_entries.sort_by { |h| h["Average"] }.reverse
          else
            @table_entries
          end
        end

        def grouped_prs_by_time_and_user
          @grouped_prs_by_time_and_user ||= grouped_prs_by_time.inject({}) do |result, (time, prs)|
            result[time] = Reports::Aggregate.new(prs: prs, users: users).run do |pr, user|
              pr.user == user
            end
            result
          end
        end

        def grouped_prs_by_time_and_reviewer
          @grouped_prs_by_time_and_reviewer ||= grouped_prs_by_time.inject({}) do |result, (time, prs)|
            result[time] = Reports::Aggregate.new(prs: prs, users: reviewers).run do |pr, reviewer|
              pr.reviewers.include?(reviewer)
            end
            result
          end
        end

        def grouped_prs_by_time(type = @group_by)
          @grouped_prs_by ||= prs.sort_by(&type.to_sym).group_by(&type.to_sym)
        end

        def grouped_prs_by_user
          @grouped_prs_by_user ||= prs.group_by(&:user)
        end

        def grouped_prs_by_reviewer
          @grouped_prs_by_reviewer ||= Reports::Aggregate.new(prs: prs, users: reviewers).run do |pr, reviewer|
            pr.reviewers.include?(reviewer)
          end
        end

        def users
          @users ||= prs.group_by(&:user).keys
        end

        def reviewers
          @reviewers ||= prs.flat_map(&:reviewers).uniq
        end

        def show_total?
          @show_total
        end

        def show_average?
          @show_average
        end

        def average
          @average ||= data_sets.map do |k, v|
            [k, Math.mean(v).round(2)]
          end.to_h
        end

        def sum
          @sum ||= data_sets.map do |k, v|
            [k, v.reduce(:+).round(2)]
          end.to_h
        end

        def load_reviews
          puts "Loading PR reviews"
          prs.each do |pr|
            pr.review_required?
            progress_bar.increment!
          end
          progress_bar.increment! @prs.size
        end

        def progress_bar
          @progress_bar ||= ProgressBar.new(@prs.size, :elapsed, :bar, :counter, :rate)
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

        def prs
          raise NotImplementedError
        end
    end
  end
end
