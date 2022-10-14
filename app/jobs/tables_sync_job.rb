class TablesSyncJob < ApplicationJob
  queue_as :default

  def perform(database_table)
    database_table.sync_fields
  end
end
