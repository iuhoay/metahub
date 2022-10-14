class Database < ApplicationRecord
  self.table_name = 'connect_databases'

  has_many :schemas, class_name: 'DatabaseSchema', foreign_key: 'connect_database_id'

  validates :name, presence: true
  validates :kind, presence: true
  validates :host, presence: true
  validates :port, presence: true

  def url
    "#{kind}://#{host}:#{port}"
  end
end
