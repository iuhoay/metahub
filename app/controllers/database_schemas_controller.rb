class DatabaseSchemasController < ApplicationController
  before_action :set_database_schema, only: [:show, :edit, :update, :destroy, :sync_tables, :pin, :unpin, :export_hive]
  before_action :set_breadcrumbs, except: [:index]

  def index
    authorize DatabaseSchema
    @database_schemas = DatabaseSchema.includes(:database).pinned.order(:name)
  end

  def show
    @q = @database_schema.tables.ransack(params[:q])
    @tables = @q.result
  end

  def sync_tables
    # @database_schema.sync_tables
    SchemaSyncJob.perform_later(@database_schema)
    redirect_to database_database_schema_url(@database, @database_schema), notice: "Database schema was successfully synced."
  end

  def pin
    @database_schema.update(pin_at: Time.now)
    redirect_to database_database_schema_url(@database, @database_schema), notice: "Database table was successfully pinned."
  end

  def unpin
    @database_schema.update(pin_at: nil)
    redirect_to database_database_schema_url(@database, @database_schema), notice: "Database table was successfully unpinned."
  end

  def export_hive
    CreateSqlFileJob.perform_later(@database_schema)
    redirect_to database_database_schema_url(@database, @database_schema), notice: "SQL files was successfully created."
  end

  def edit
    add_breadcrumb "Edit"
  end

  def update
    if @database_schema.update(database_schema_params)
      redirect_to database_database_schema_url(@database, @database_schema), notice: "Database schema was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_database_schema
    @database_schema = DatabaseSchema.find(params[:id])
    @database = @database_schema.database
    authorize @database_schema
  end

  def database_schema_params
    params.require(:database_schema).permit(:alias_name, :hive_table_prefix, :comment_name, :column_name_style)
  end

  def set_breadcrumbs
    add_breadcrumb "Home", root_url
    add_breadcrumb @database.name, database_path(@database) if @database
    add_breadcrumb @database_schema.name, database_database_schema_path(@database, @database_schema) if @database_schema
  end
end
