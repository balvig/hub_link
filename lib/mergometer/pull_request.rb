class PullRequest
  QUICK_FIX_CUTOFF = 5
  LONG_RUNNING_LENGTH = 4 * 24 * 60 * 60 # Days
  HEAVILY_COMMENTED_COUNT = 10

  def initialize(data)
    @data = data
  end

  def number
    data.number
  end

  def user
    data.user.login
  end

  # Metrics

  def problematic?
    long_running? || heavily_commented?
  end

  def quick_fix?
    changes < QUICK_FIX_CUTOFF
  end

  def long_running?
    merge_time_in_seconds > LONG_RUNNING_LENGTH
  end

  def heavily_commented?
    comment_count > HEAVILY_COMMENTED_COUNT
  end

  def comment_count
    @_comment_count ||= data.comments + comment_data.size
  end

  def merge_time
    @_merge_time ||= (merge_time_in_seconds / 60 / 60).round
  end

  def preload
    comment_data && pr_data
  end

  private

    attr_accessor :data

    def merge_time_in_seconds
      data.closed_at - data.created_at
    end

    def changes
      @_changes ||= pr_data.additions + pr_data.deletions
    end

    def comment_data
      @_comment_data ||= Octokit.get(pr_data.review_comments_url)
    end

    def pr_data
      @_pr_data ||= Octokit.get(data.pull_request.url)
    end
end
