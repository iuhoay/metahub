require "test_helper"

class DatabaseSchemaTest < ActiveSupport::TestCase
  test "ods_schema_name" do
    database_schema = DatabaseSchema.new(name: "test", alias_name: "test_alias")
    assert_equal "test_alias", database_schema.ods_schema_name
  end

  test "ods_schema_name without alias_name" do
    database_schema = DatabaseSchema.new(name: "test")
    assert_equal "test", database_schema.ods_schema_name
  end

  test "column_name_style" do
    database_schema = DatabaseSchema.new
    assert_equal true, database_schema.column_name_style_snake_case?
    assert_equal false, database_schema.column_name_style_lowercase?

    database_schema = DatabaseSchema.new(column_name_style: "lowercase")
    assert_equal true, database_schema.column_name_style_lowercase?
    assert_equal false, database_schema.column_name_style_snake_case?
  end
end
