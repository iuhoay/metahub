class CreateSqlFileJob < ApplicationJob
  queue_as :default

  def perform(database_schema)
    database_schema.tables.each do |table|
      table.generate_sql_script
      table.generate_datax_script
    end
  end
end
