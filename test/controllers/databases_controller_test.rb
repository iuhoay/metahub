require "test_helper"

class DatabasesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get databases_index_url
    assert_response :success
  end
end
