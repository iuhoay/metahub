class DatabaseTablesController < ApplicationController
  before_action :set_database_table, only: [:show, :edit, :update, :destroy, :sync_fields]

  def sync_fields
    @database_table.sync_fields
    redirect_to [@database, @database_schema, @database_table], notice: 'Database table was successfully synced.'
  end

  private

  def set_database_table
    @database_table = DatabaseTable.find(params[:id])
    @database_schema = @database_table.database_schema
    @database = @database_schema.database
  end
end
