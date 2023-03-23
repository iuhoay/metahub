class TableField < ApplicationRecord
  belongs_to :database_table

  acts_as_list scope: :database_table

  DATA_TYPE_REGEX = /(?<type>\w+)\(?(?<length>\d+)?,?((?<scale>\d+))?/

  def self.ransackable_attributes(auth_object = nil)
    ["comment", "created_at", "data_type", "database_table_id", "default_value", "field", "field_extra", "id", "key", "nullable", "position", "updated_at"]
  end

  def to_hive_column
    "`#{to_hive_column_name}` #{get_hive_type}"
  end

  def to_hive_column_name
    ActiveSupport::Inflector.underscore(field)
  end

  def get_hive_type
    case data_type_name.downcase
    when "varchar", "char", "text", "longtext", "mediumtext", "tinytext", "json", "varbinary", "longblob", "mediumblob", "string"
      "string"
    when "int", "tinyint", "smallint", "mediumint", "bigint", "uint32", "uint16", "int16", "int32"
      "bigint"
    when "decimal", "double", "float"
      "decimal(#{data_type_length}, #{data_type_scale})"
    when "date", "datetime", "timestamp"
      "string"
    else
      raise "Unknown data type: #{data_type}, table: #{database_table.name}"
    end
  end

  def get_hive_type_on_datax
    case data_type_name.downcase
    when "varchar", "char", "text", "longtext", "mediumtext", "tinytext", "json", "varbinary", "longblob", "mediumblob", "string"
      "string"
    when "int", "tinyint", "smallint", "mediumint", "bigint", "uint32", "uint16", "int16", "int32"
      "bigint"
    when "decimal", "double", "float"
      "double"
    when "date", "datetime", "timestamp"
      "string"
    else
      raise "Unknown data type: #{data_type}, table: #{database_table.name}"
    end
  end

  def data_type_name
    data_type.match(DATA_TYPE_REGEX)[:type]
  end

  def data_type_length
    match = data_type.match(DATA_TYPE_REGEX)
    if match && match[:length]
      match[:length].to_i
    end
  end

  def data_type_scale
    match = data_type.match(DATA_TYPE_REGEX)
    if match && match[:scale]
      match[:scale].to_i
    end
  end
end
