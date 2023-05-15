require "test_helper"

class DatabaseTableTest < ActiveSupport::TestCase
  test "is full sync" do
    database_table = DatabaseTable.new(sync_method: :all_dd)
    assert database_table.sync_all_dd?
  end

  test "is incremental sync" do
    database_table = DatabaseTable.new(sync_method: :add_dd)
    assert database_table.sync_add_dd?
  end
end
