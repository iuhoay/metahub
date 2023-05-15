class DatabaseTablesController < ApplicationController
  before_action :set_database_table, only: [:show, :sync_fields, :edit, :update]
  before_action :set_breadcrumbs
  before_action :set_table_navs, only: [:show, :edit]

  def sync_fields
    @database_table.sync_fields
    redirect_to database_database_schema_database_table_path(@database, @database_schema, @database_table), notice: "Database table was successfully synced."
  end

  def show
    @q = @database_table.table_fields.ransack(params[:q])
    @table_fields = @q.result
  end

  def edit
    @current_tab = "edit"
  end

  def update
    authorize @database_table
    if @database_table.update(database_table_params)
      redirect_to database_database_schema_database_table_path(@database, @database_schema, @database_table), notice: "Database table was successfully updated."
    else
      render :edit
    end
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

  def set_table_navs
    @current_tab = params[:tab] || "columns"
    @table_navs = [
      {tab: "columns", name: "Columns"},
      {tab: "ddl", name: "DDL - #{@database_table.sync_method}"},
      {tab: "datax", name: "DataX - #{@database_table.sync_method}"},
      {tab: "edit", name: "Settings", action: [:edit, @database.become, @database_schema, @database_table]}
    ]
  end

  def database_table_params
    params.require(:database_table).permit(:sync_method)
  end
end
