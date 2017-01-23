class Float
  require "action_view"
  include ActionView::Helpers::DateHelper

  def in_words
    distance_of_time_in_words self
  end
end

