class AddSyncMethodToDatabaseTables < ActiveRecord::Migration[7.0]
  def change
    add_column :database_tables, :sync_method, :integer, default: 0
  end
end
