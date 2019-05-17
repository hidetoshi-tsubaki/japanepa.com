require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

<<<<<<< HEAD
  test "should get question" do
    get static_pages_question_url
    assert_response :success
  end

  test "should get score" do
    get static_pages_score_url
=======
  test "should get about" do
    get static_pages_about_url
>>>>>>> origin/master
    assert_response :success
  end

end
