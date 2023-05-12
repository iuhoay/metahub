class AddColumnNameStyleToDatabaseSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :column_name_style, :integer, default: 1, null: false
  end
end
