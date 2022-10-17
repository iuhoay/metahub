class DatabaseSchema < ApplicationRecord
  belongs_to :database, class_name: 'Database', foreign_key: 'connect_database_id'
  has_many :tables, class_name: 'DatabaseTable', foreign_key: 'database_schema_id'

  def ods_schema_name
    "ods_#{alias_name || name}"
  end

  def sync_tables
    conn = database.get_connection(name)
    conn.query('SHOW TABLE STATUS').each do |row|
      table = tables.find_or_initialize_by(name: row['Name'])
      table.comment = row['Comment']
      table.save!
    end
  end
end
