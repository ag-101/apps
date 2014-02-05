require 'test_helper'

class Apps::ConstructControllerTest < ActionController::TestCase
  setup do
    @apps_construct = apps_constructs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apps_constructs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apps_construct" do
    assert_difference('Apps::Construct.count') do
      post :create, apps_construct: {  }
    end

    assert_redirected_to apps_construct_path(assigns(:apps_construct))
  end

  test "should show apps_construct" do
    get :show, id: @apps_construct
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apps_construct
    assert_response :success
  end

  test "should update apps_construct" do
    put :update, id: @apps_construct, apps_construct: {  }
    assert_redirected_to apps_construct_path(assigns(:apps_construct))
  end

  test "should destroy apps_construct" do
    assert_difference('Apps::Construct.count', -1) do
      delete :destroy, id: @apps_construct
    end

    assert_redirected_to apps_constructs_path
  end
end
