require 'test_helper'

class EvaluationSessionsControllerTest < ActionController::TestCase
  setup do
    @evaluation_session = evaluation_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_session" do
    assert_difference('EvaluationSession.count') do
      post :create, evaluation_session: {  }
    end

    assert_redirected_to evaluation_session_path(assigns(:evaluation_session))
  end

  test "should show evaluation_session" do
    get :show, id: @evaluation_session
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_session
    assert_response :success
  end

  test "should update evaluation_session" do
    patch :update, id: @evaluation_session, evaluation_session: {  }
    assert_redirected_to evaluation_session_path(assigns(:evaluation_session))
  end

  test "should destroy evaluation_session" do
    assert_difference('EvaluationSession.count', -1) do
      delete :destroy, id: @evaluation_session
    end

    assert_redirected_to evaluation_sessions_path
  end
end
