require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get share" do
    get :share
    assert_response :success
  end

  test "should get analysis" do
    get :analysis
    assert_response :success
  end

  test "should get show_donor" do
    get :show_donor
    assert_response :success
  end

end
