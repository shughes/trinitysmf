require File.dirname(__FILE__) + '/../test_helper'

class ResumeViewerTest < Test::Unit::TestCase
  fixtures :resume_viewers

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ResumeViewer, resume_viewers(:first)
  end
end
