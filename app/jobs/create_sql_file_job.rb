class CreateSqlFileJob < ApplicationJob
  queue_as :default

  def perform(database_schema)
    database_schema.tables.each do |table|
      table.generate_sql_script
      table.generate_datax_script
      table.generate_dwd_job
    end
    database_schema.generate_jobs
  end
end
