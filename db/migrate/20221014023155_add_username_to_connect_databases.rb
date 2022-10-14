class AddUsernameToConnectDatabases < ActiveRecord::Migration[7.0]
  def change
    add_column :connect_databases, :username, :string
    add_column :connect_databases, :password, :string
  end
end
