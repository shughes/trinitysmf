require File.dirname(__FILE__) + '/../test_helper'
require 'job_announcement_controller'

# Re-raise errors caught by the controller.
class JobAnnouncementController; def rescue_action(e) raise e end; end

class JobAnnouncementControllerTest < Test::Unit::TestCase
  def setup
    @controller = JobAnnouncementController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
