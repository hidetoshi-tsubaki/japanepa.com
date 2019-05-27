require 'test_helper'

class AticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get aticles_new_url
    assert_response :success
  end

  test "should get create" do
    get aticles_create_url
    assert_response :success
  end

  test "should get index" do
    get aticles_index_url
    assert_response :success
  end

  test "should get show" do
    get aticles_show_url
    assert_response :success
  end

  test "should get edit" do
    get aticles_edit_url
    assert_response :success
  end

  test "should get update" do
    get aticles_update_url
    assert_response :success
  end

  test "should get delete" do
    get aticles_delete_url
    assert_response :success
  end

end
