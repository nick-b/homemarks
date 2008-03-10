require File.dirname(__FILE__) + '/../test_helper'
require 'action_area_controller'

# Re-raise errors caught by the controller.
class ActionAreaController; def rescue_action(e) raise e end; end

class ActionAreaControllerTest < Test::Unit::TestCase
  def setup
    @controller = ActionAreaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
