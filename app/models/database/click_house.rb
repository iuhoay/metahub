class Database::ClickHouse < Database
  def get_connection(database = nil)
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
      {name: row["name"], comment: row["comment"]}
    end
  end

  def fetch_all_column(schema_name, table_name)
    raise "schema_name is required" if schema_name.blank?
    raise "table_name is required" if table_name.blank?

    get_connection(schema_name).select_all("SELECT name, type, comment, default_expression FROM system.columns WHERE database = '#{schema_name}' AND table = '#{table_name}' ").map do |row|
      {name: row["name"], type: row["type"], comment: row["comment"], key: nil, nullable: nil, default: row["default_expression"], extra: nil}
        .merge(parse_type(row["type"]))
    end
  end

  private

  def parse_type(type)
    return {type: $1.to_s, nullable: true} if /Nullable\((.*)\)/ =~ type
    {type: type, nullable: false}
  end
end
