class DatabaseSchemasController < ApplicationController
  before_action :set_database_schema, only: [:show, :edit, :update, :destroy, :sync_tables]

  def sync_tables
    @database_schema.sync_tables
    redirect_to @database_schema.database, notice: 'Database schema was successfully synced.'
  end

  private

  def set_database_schema
    @database_schema = DatabaseSchema.find(params[:id])
    @database = @database_schema.database
  end
end
