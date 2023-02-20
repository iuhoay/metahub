class Database::Mysql < Database
  def get_connection(database=nil)
    Mysql2::Client.new(host: host, port: port, username: username, password: password, database: database)
  end

  def url
    "mysql://#{host}:#{port}"
  end

  def sync_schemas
    get_connection.query('SHOW DATABASES').each do |row|
      schema = schemas.find_or_create_by!(name: row['Database'])
    end
  end
end
