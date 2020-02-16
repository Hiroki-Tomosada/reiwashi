require 'test_helper'

class FabsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fab = fabs(:one)
  end

  test "should get index" do
    get fabs_url, as: :json
    assert_response :success
  end

  test "should create fab" do
    assert_difference('Fab.count') do
      post fabs_url, params: { fab: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fab" do
    get fab_url(@fab), as: :json
    assert_response :success
  end

  test "should update fab" do
    patch fab_url(@fab), params: { fab: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fab" do
    assert_difference('Fab.count', -1) do
      delete fab_url(@fab), as: :json
    end

    assert_response 204
  end
end
