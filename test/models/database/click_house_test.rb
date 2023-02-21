require "test_helper"

class Database::ClickHouseTest < ActiveSupport::TestCase


  test "parse_type" do
    db = Database::ClickHouse.new
    assert_equal({ type: "Int32", nullable: false }, db.send(:parse_type, "Int32"))
    assert_equal({ type: "Int32", nullable: true }, db.send(:parse_type, "Nullable(Int32)"))
  end

end
