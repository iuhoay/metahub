require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should get admin user" do
    admin = users(:admin)
    assert_not_nil admin
  end

  test "should get two users" do
    users = User.all
    assert_equal 2, users.size
  end
end
