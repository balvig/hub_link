class PullRequest
  QUICK_FIX_CUTOFF = 6 # Changes
  LONG_RUNNING_LENGTH = 5 * 24 * 60 * 60 # Days
  HEAVILY_COMMENTED_COUNT = 20 # Comments

  def initialize(data)
    @data = data
  end

  def number
    data.number
  end

  def user
    data.user.login
  end

  def week
    data.created_at.beginning_of_week
  end

  # Metrics

  def problematic?
    heavily_commented?
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
    reviewers && pr_data
  end

  def changes
    @_changes ||= pr_data.additions + pr_data.deletions
  end

  def reviewers
    @_reviewers ||= Octokit.pull_request_reviews(repo, number).map(&:user).map(&:login).uniq - %w(houndci-bot)
  end

  private

    attr_accessor :data

    def merge_time_in_seconds
      data.closed_at - data.created_at
    end

    def comment_data
      @_comment_data ||= Octokit.get(pr_data.review_comments_url)
    end

    def pr_data
      @_pr_data ||= Octokit.get(data.pull_request.url)
    end

    def number
      pr_data.number
    end

    def repo
      pr_data.base.repo.full_name
    end
end
