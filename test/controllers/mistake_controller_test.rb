require 'test_helper'

class MistakeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mistake_index_url
    assert_response :success
  end

  test "should get show" do
    get mistake_show_url
    assert_response :success
  end

end
