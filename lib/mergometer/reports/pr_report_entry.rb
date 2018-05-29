module Mergometer
  module Reports
    class PrReportEntry
      def initialize(prs:)
        @prs = prs
      end

      def total_pr_count
        prs.size
      end

      def eligible_pr_count
        eligible_prs.size
      end

      def problem_ratio
        @problem_ratio ||= ((problematic_count / eligible_pr_count.to_f) * 100).round(2)
      end

      def quick_fix_ratio
        @quick_fix_ratio ||= quick_fix_count / eligible_pr_count.to_f
      end

      def problematic_count
        @problematic_count ||= prs.count(&:problematic?)
      end

      def quick_fix_count
        @quick_fix_count ||= prs.count(&:quick_fix?)
      end

      def long_running_count
        @long_running_count ||= prs.count(&:long_running?)
      end

      def heavily_commented_count
        @heavily_commented_count ||= prs.count(&:heavily_commented?)
      end

      def inactive?
        eligible_pr_count < 1
      end

      # Metrics

      def average_comment_count
        @comment_count ||= calculate_metric(:comment_count)
      end

      def average_merge_time
        @merge_time ||= calculate_metric(:merge_time)
      end

      def average_changes
        @changes ||= calculate_metric(:changes)
      end

      private

        attr_accessor :prs, :repos

        def calculate_metric(metric)
          Math.mean(eligible_prs.map(&metric).compact).round(2)
        end

        def eligible_prs
          @eligible_prs ||= prs.reject(&:quick_fix?)
        end
    end
  end
end
