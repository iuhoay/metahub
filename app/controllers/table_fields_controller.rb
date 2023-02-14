class TableFieldsController < ApplicationController
  before_action :set_database_table
  before_action :set_table_field, only: [:show, :edit, :update, :destroy]

  def update
    @table_field.update(table_field_params)
    redirect_to database_database_schema_database_table_path(@database, @database_schema, @database_table)
  end

  private

  def set_database_table
    @database_table = DatabaseTable.find(params[:database_table_id])
    @database_schema = @database_table.database_schema
    @database = @database_schema.database
  end

  def set_table_field
    @table_field = @database_table.table_fields.find(params[:id])
  end

  def table_field_params
    params.required(:table_field).permit(:position)
  end
end
