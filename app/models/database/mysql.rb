class Database::Mysql < Database
  def get_connection(database = nil)
    Mysql2::Client.new(
      host: host,
      port: port,
      username: username,
      password: password,
      database: database,
      connect_timeout: 5
    )
  rescue Mysql2::Error::ConnectionError => e
    raise DatabaseConnectionError, e.message
  end

  def url
    "mysql://#{host}:#{port}"
  end

  def sync_schemas
    get_connection.query("SHOW DATABASES").each do |row|
      schema = schemas.find_or_create_by!(name: row["Database"])
    end
  end

  def fetch_all_table(schema_name)
    raise "schema_name is required" if schema_name.blank?
    get_connection(schema_name).query("SHOW TABLE STATUS").map do |row|
      {name: row["Name"], comment: row["Comment"]}
    end
  end

  def fetch_all_column(schema_name, table_name)
    raise "schema_name is required" if schema_name.blank?
    raise "table_name is required" if table_name.blank?
    get_connection(schema_name).query("SHOW FULL COLUMNS FROM #{table_name}").map do |row|
      {name: row["Field"], type: row["Type"], comment: row["Comment"], key: row["Key"], nullable: row["Null"] == "YES", default: row["Default"], extra: row["Extra"]}
    end
  end
end
