class AddPinAtToDatabaseSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :pin_at, :datetime
  end
end
