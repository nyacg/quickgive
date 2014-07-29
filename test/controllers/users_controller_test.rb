require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new_campaigner" do
    get :new_campaigner
    assert_response :success
  end

  test "should get new_donor" do
    get :new_donor
    assert_response :success
  end

end
