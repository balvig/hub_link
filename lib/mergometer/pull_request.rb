class PullRequest
  QUICK_FIX_CUTOFF = 5

  def initialize(data)
    @data = data
  end

  def number
    data.number
  end

  def title
    data.title
  end

  def user
    data.user.login
  end

  def merge_time
    @_merge_time ||= data.closed_at - data.created_at
  end

  def quick_fix?
    false
    #changes < QUICK_FIX_CUTOFF
  end

  private

    attr_accessor :data

    #def full_data
      #@_full_data =
    #end

    def changes
      data.additions + data.deletions
    end
end
