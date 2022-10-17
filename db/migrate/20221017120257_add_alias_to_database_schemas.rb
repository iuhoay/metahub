class AddAliasToDatabaseSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :alias_name, :string
  end
end
