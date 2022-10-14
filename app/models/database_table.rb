class DatabaseTable < ApplicationRecord
  belongs_to :database_schema, counter_cache: true
end
