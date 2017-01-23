class Ranking
  require "facets/math"

  ACTIVITY_LOWER_LIMIT = 15

  attr_accessor :user

  def initialize(user, prs:)
    @user = user
    @prs = prs
  end

  def eligible_pr_count
    eligible_prs.size
  end

  def counts
    "#{eligible_pr_count} (#{prs.size})"
  end

  def inactive?
    eligible_pr_count < ACTIVITY_LOWER_LIMIT
  end

  # Metrics
  def comment_count
    @_comment_count ||= calculate_metric(:comment_count)
  end

  def merge_time
    @_merge_time ||= calculate_metric(:merge_time)
  end

  private

    attr_accessor :prs

    def calculate_metric(metric)
      Math.median eligible_prs.map(&metric)
    end

    def eligible_prs
      @_eligible_prs ||= prs.reject(&:quick_fix?)
    end
end
