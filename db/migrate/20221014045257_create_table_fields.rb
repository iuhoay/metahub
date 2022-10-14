class CreateTableFields < ActiveRecord::Migration[7.0]
  def change
    create_table :table_fields do |t|
      t.belongs_to :database_table, null: false, foreign_key: true
      t.string :field
      t.string :data_type
      t.string :key
      t.boolean :nullable
      t.string :default_value
      t.string :field_extra
      t.string :comment

      t.timestamps
    end
  end
end
