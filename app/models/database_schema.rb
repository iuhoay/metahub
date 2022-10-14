class DatabaseSchema < ApplicationRecord
  belongs_to :database, class_name: 'Database', foreign_key: 'connect_database_id'
end
