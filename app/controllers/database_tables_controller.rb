class DatabaseTablesController < ApplicationController
  before_action :set_database_table, only: [:show, :sync_fields]
  before_action :set_breadcrumbs

  def sync_fields
    @database_table.sync_fields
    redirect_to database_database_schema_database_table_path(@database, @database_schema, @database_table), notice: "Database table was successfully synced."
  end

  def show
    @q = @database_table.table_fields.ransack(params[:q])
    @table_fields = @q.result
  end

  private

  def set_database_table
    @database_table = DatabaseTable.find(params[:id])
    @database_schema = @database_table.database_schema
    @database = @database_table.database
    authorize @database_table
  end

  def set_breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb @database.name, database_path(@database)
    add_breadcrumb @database_schema.name, database_database_schema_path(@database, @database_schema)
    add_breadcrumb @database_table.name
  end
end
