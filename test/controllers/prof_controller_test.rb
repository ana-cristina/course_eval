require 'test_helper'

class ProfControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
