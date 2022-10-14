class SchemaSyncJob < ApplicationJob
  queue_as :default

  def perform(database_schema)
    database_schema.sync_tables
    database_schema.tables.each do |table|
      TablesSyncJob.perform_later(table)
    end
  end
end
