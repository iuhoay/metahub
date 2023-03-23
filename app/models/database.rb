class Database < ApplicationRecord
  self.table_name = "connect_databases"

  enum kind: {mysql: "mysql", click_house: "click_house"}, _suffix: true

  has_many :schemas, class_name: "DatabaseSchema", foreign_key: "connect_database_id"

  validates :name, presence: true
  validates :kind, presence: true
  validates :host, presence: true
  validates :port, presence: true
  validates :username, presence: true

  before_save :set_type

  def get_connection(database)
    raise "not implemented"
  end

  def sync_schemas
    raise "not implemented"
  end

  def fetch_all_table(schema_name)
    raise "not implemented"
  end

  def fetch_all_column(schema_name, table_name)
    raise "not implemented"
  end

  private

  def set_type
    self.type = "Database::#{kind.camelize}"
  end
end
