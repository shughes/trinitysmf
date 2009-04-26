require File.dirname(__FILE__) + '/../test_helper'

class ResumeTest < Test::Unit::TestCase
  fixtures :resumes

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Resume, resumes(:first)
  end
end
