class Database::ClickHouse < Database

  def get_connection(database=nil)
    ::ClickHouse::Connection.new(::ClickHouse::Config.new(
      logger: Rails.logger,
      host: host,
      port: port,
      database: database,
      username: username,
      password: password
    ))
  end

  def ping
    get_connection.ping
  end

  def sync_schemas
    get_connection.databases.each do |database|
      schema = schemas.find_or_create_by!(name: database)
    end
  end
end
