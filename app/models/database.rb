class Database < ApplicationRecord
  self.table_name = 'connect_databases'

  validates :name, presence: true
  validates :kind, presence: true
  validates :url, presence: true
end
