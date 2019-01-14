require 'test_helper'

module HubLink
  class SlicerTest < Minitest::Test
    def test_removing_question_marks
      sliceable = Api::Review.new(OpenStruct.new(state: false))

      result = Slicer.new(sliceable, columns: %i(approval?)).to_h

      assert_equal({ approval: false }, result)
    end
  end
end
