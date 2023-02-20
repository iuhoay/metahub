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

  def fetch_all_table(schema_name)
    raise "schema_name is required" if schema_name.blank?
    get_connection(schema_name).select_all("SELECT name, comment FROM system.tables WHERE database = '#{schema_name}' ").map do |row|
      { name: row['name'], comment: row['comment'] }
    end
  end
end
