require "test_helper"

class TableFieldTest < ActiveSupport::TestCase
  test "data_type_name with enum" do
    field = TableField.new
    field.data_type = "enum('a','b')"
    assert_equal "enum", field.data_type_name
    assert_equal "string", field.get_hive_type
  end

  test "data_type_name" do
    field = TableField.new
    field.data_type = "int(11)"
    assert_equal "int", field.data_type_name
  end

  test "data_type_length" do
    field = TableField.new
    field.data_type = "int(11)"
    assert_equal 11, field.data_type_length
  end

  test "data_type_length with no length" do
    field = TableField.new
    field.data_type = "int"
    assert_nil field.data_type_length
  end

  test "data_type_length with decimal" do
    field = TableField.new
    field.data_type = "decimal(10,2)"
    assert_equal 10, field.data_type_length
  end

  test "data_type_scale with decimal" do
    field = TableField.new
    field.data_type = "decimal(10,2)"
    assert_equal 2, field.data_type_scale
  end

  test "get_hive_type" do
    field = TableField.new
    field.data_type = "int(11)"
    assert_equal "bigint", field.get_hive_type

    field.data_type = "UInt32"
    assert_equal "bigint", field.get_hive_type

    field.data_type = "UInt16"
    assert_equal "bigint", field.get_hive_type

    field.data_type = "String"
    assert_equal "string", field.get_hive_type

    field.data_type = "enum('manager', 'customer')"
    assert_equal "string", field.get_hive_type
  end
end
