class DatabaseTable < ApplicationRecord
  belongs_to :database_schema, counter_cache: true
  has_many :table_fields, dependent: :destroy

  def sync_fields
    conn = database_schema.database.get_connection(database_schema.name)

    conn.query('SHOW FULL COLUMNS FROM ' + name).each do |field|
      table_field = table_fields.find_or_initialize_by(field: field['Field'])
      table_field.data_type = field['Type']
      table_field.key = field['Key']
      table_field.nullable = field['Null'] == 'YES'
      table_field.default_value = field['Default']
      table_field.field_extra = field['Extra']
      table_field.comment = field['Comment']
      table_field.save!
    end
    conn.close
  end
end
