class PullRequest
  QUICK_FIX_CUTOFF = 5

  def initialize(data)
    @data = data
  end

  def number
    data.number
  end

  def user
    data.user.login
  end

  def quick_fix?
    changes < QUICK_FIX_CUTOFF
  end

  # Metrics
  def comment_count
    @_comment_count ||= data.comments + review_comments.size
  end

  def merge_time
    @_merge_time ||= data.closed_at - data.created_at
  end

  def changes
    @_changes ||= full_data.additions + full_data.deletions
  end

  private

    attr_accessor :data

    def review_comments
      @_review_comments ||= Octokit.get(full_data.review_comments_url)
    end

    def full_data
      @_full_data ||= Octokit.get(api_url)
    end

    def api_url
      data.pull_request.url
    end
end
