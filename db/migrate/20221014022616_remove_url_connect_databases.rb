class RemoveUrlConnectDatabases < ActiveRecord::Migration[7.0]
  def change
    remove_column :connect_databases, :url, :string
  end
end
