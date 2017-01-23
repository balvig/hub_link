class Ranking
  ACTIVITY_LOWER_LIMIT = 15

  attr_accessor :user

  def initialize(user, prs:)
    @user = user
    @prs = prs
  end

  def total_count
    prs.size
  end

  def formatted_merge_time
    median_merge_time.in_words
  end

  def formatted_slowest_merge
    "##{slowest_merge.number} " + "(#{slowest_merge.merge_time.in_words})"
  end

  def median_merge_time
    @_median_merge_time ||= Math.median prs.map(&:merge_time)
  end

  def inactive?
    total_count < ACTIVITY_LOWER_LIMIT
  end

  private

    attr_accessor :prs

    def prs
      @_prs ||= @prs.reject(&:quick_fix?)
    end

    def slowest_merge
      @_slowest_merge ||= prs.max_by(&:merge_time)
    end
end
