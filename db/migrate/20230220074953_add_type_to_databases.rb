class AddTypeToDatabases < ActiveRecord::Migration[7.0]
  def up
    add_column :connect_databases, :type, :string

    Database.all.each do |database|
      database.type = "Database::#{database.kind.camelize}"
      database.save
    end
  end

  def down
    remove_column :connect_databases, :type
  end
end
