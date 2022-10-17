require "test_helper"

class DatabaseSchemaTest < ActiveSupport::TestCase

  test "ods_schema_name" do
    database_schema = DatabaseSchema.new(name: "test", alias_name: "test_alias")
    assert_equal "ods_test_alias", database_schema.ods_schema_name
  end

  test "ods_schema_name without alias_name" do
    database_schema = DatabaseSchema.new(name: "test")
    assert_equal "ods_test", database_schema.ods_schema_name
  end
end
