require File.dirname(__FILE__) + '/../test_helper'
require 'picture_controller'

# Re-raise errors caught by the controller.
class PictureController; def rescue_action(e) raise e end; end

class PictureControllerTest < Test::Unit::TestCase
  def setup
    @controller = PictureController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
