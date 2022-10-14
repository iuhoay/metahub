class CreateDatabaseTables < ActiveRecord::Migration[7.0]
  def change
    create_table :database_tables do |t|
      t.string :name
      t.belongs_to :database_schema, null: false, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
