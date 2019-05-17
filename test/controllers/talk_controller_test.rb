require 'test_helper'

class TalkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get talk_index_url
    assert_response :success
  end

  test "should get show" do
    get talk_show_url
    assert_response :success
  end

end
