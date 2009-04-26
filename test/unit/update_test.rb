require File.dirname(__FILE__) + '/../test_helper'

class UpdateTest < Test::Unit::TestCase
  fixtures :updates

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Update, updates(:first)
  end
end
