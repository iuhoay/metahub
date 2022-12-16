class DatabaseSchemasController < ApplicationController
  before_action :set_database_schema, only: [:show, :edit, :update, :destroy, :sync_tables, :pin, :unpin, :export_hive]

  def index
    @database_schemas = DatabaseSchema.where.not(pin_at: nil).order(:name)
  end

  def sync_tables
    # @database_schema.sync_tables
    SchemaSyncJob.perform_later(@database_schema)
    redirect_to [@database_schema.database, @database_schema], notice: 'Database schema was successfully synced.'
  end

  def pin
    @database_schema.update(pin_at: Time.now)
    redirect_to [@database, @database_schema], notice: 'Database table was successfully pinned.'
  end

  def unpin
    @database_schema.update(pin_at: nil)
    redirect_to [@database, @database_schema], notice: 'Database table was successfully unpinned.'
  end

  def export_hive
    CreateSqlFileJob.perform_later(@database_schema)
    redirect_to [@database, @database_schema], notice: 'SQL files was successfully created.'
  end

  def update
    if @database_schema.update(database_schema_params)
      redirect_to [@database, @database_schema], notice: 'Database schema was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_database_schema
    @database_schema = DatabaseSchema.find(params[:id])
    @database = @database_schema.database
  end

  def database_schema_params
    params.require(:database_schema).permit(:alias_name, :hive_table_prefix, :comment_name)
  end
end
