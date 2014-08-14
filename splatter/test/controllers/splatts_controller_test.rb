require 'test_helper'

class SplattsControllerTest < ActionController::TestCase
  setup do
    @splatt = splatts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:splatts)
  end

  test "should create splatt" do
    assert_difference('Splatt.count') do
      post :create, splatt: { body: @splatt.body, user_id: @splatt.user_id }
    end

    assert_response 201
  end

  test "should show splatt" do
    get :show, id: @splatt
    assert_response :success
  end

  test "should update splatt" do
    put :update, id: @splatt, splatt: { body: @splatt.body, user_id: @splatt.user_id }
    assert_response 204
  end

  test "should destroy splatt" do
    assert_difference('Splatt.count', -1) do
      delete :destroy, id: @splatt
    end

    assert_response 204
  end
end
