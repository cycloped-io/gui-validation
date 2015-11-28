require 'test_helper'

class DecisionsControllerTest < ActionController::TestCase
  test "should get next" do
    get :next
    assert_response :success
  end

  test "should get previous" do
    get :previous
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
