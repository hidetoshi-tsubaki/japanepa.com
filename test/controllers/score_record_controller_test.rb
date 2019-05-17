require 'test_helper'

class ScoreRecordControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get score_record_create_url
    assert_response :success
  end

  test "should get index" do
    get score_record_index_url
    assert_response :success
  end

  test "should get show" do
    get score_record_show_url
    assert_response :success
  end

end
