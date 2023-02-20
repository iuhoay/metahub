require "test_helper"

class DatabaseTest < ActiveSupport::TestCase

  test "should saved" do
    database = build(:database)
    assert database.save
  end

  test "should not save database without kind" do
    database = build(:database, kind: nil)
    assert_not database.save
  end

  test "should database kind be mysql" do
    database = create(:database, kind: :mysql)
    assert_equal "mysql", database.kind
    assert database.mysql_kind?
  end

  test "should database kind be click_house" do
    database = create(:database, kind: :click_house)
    assert_equal "click_house", database.kind
    assert database.click_house_kind?
  end

end
