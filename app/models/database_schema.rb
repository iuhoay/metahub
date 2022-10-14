class DatabaseSchema < ApplicationRecord
  belongs_to :database, class_name: 'Database', foreign_key: 'connect_database_id'
  has_many :tables, class_name: 'DatabaseTable', foreign_key: 'database_schema_id'

  def sync_tables
    conn = database.get_connection(name)
    conn.query('SHOW TABLE STATUS').each do |row|
      tables.find_or_create_by!(name: row['Name']) do |t|
        t.comment = row['Comment']
      end
    end
  end
end
