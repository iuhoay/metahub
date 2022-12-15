class AddHiveTablePrefixToDatabaseSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :hive_table_prefix, :string
  end
end
