class AddDatabaseTablesCountToDatabaseSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :database_tables_count, :integer
  end
end
