class AddHostToConnectDatabases < ActiveRecord::Migration[7.0]
  def change
    add_column :connect_databases, :host, :string
    add_column :connect_databases, :port, :integer
  end
end
