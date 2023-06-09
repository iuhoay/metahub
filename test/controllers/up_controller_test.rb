require "test_helper"

class UpControllerTest < ActionDispatch::IntegrationTest
  # test '/up' success
  test "should get up" do
    get up_url
    assert_response :success
  end
end
