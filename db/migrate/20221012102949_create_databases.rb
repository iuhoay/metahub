class CreateDatabases < ActiveRecord::Migration[7.0]
  def change
    create_table :connect_databases do |t|
      t.string :name
      t.string :kind
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
