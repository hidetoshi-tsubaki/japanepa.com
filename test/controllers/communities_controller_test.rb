require 'test_helper'

class CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get communities_index_url
    assert_response :success
  end

  test "should get create" do
    get communities_create_url
    assert_response :success
  end

  test "should get delete" do
    get communities_delete_url
    assert_response :success
  end

  test "should get update" do
    get communities_update_url
    assert_response :success
  end

end
