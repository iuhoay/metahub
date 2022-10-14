class Database < ApplicationRecord
  self.table_name = 'connect_databases'

  has_many :schemas, class_name: 'DatabaseSchema', foreign_key: 'connect_database_id'

  validates :name, presence: true
  validates :kind, presence: true
  validates :host, presence: true
  validates :port, presence: true
  validates :username, presence: true

  def get_connection(database)
    case kind
    when 'mysql'
      Mysql2::Client.new(host: host, port: port, username: username, password: password, database: database)
    end
  end

  def url
    "#{kind}://#{host}:#{port}"
  end

  def sync_schemas
    conn = Mysql2::Client.new(host: host, port: port, username: username, password: password)

    conn.query('SHOW DATABASES').each do |row|
      schema = schemas.find_or_create_by!(name: row['Database'])
    end
  end
end
