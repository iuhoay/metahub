class TableField < ApplicationRecord
  belongs_to :database_table

  DATA_TYPE_REGEX = /(?<type>\w+)\(?(?<length>\d+)?,?((?<scale>\d+))?/

  def to_hive_column
    "`#{ActiveSupport::Inflector.underscore(field)}` #{get_hive_type}"
  end

  def get_hive_type
    case data_type_name
    when 'varchar', 'char', 'text', 'longtext', 'mediumtext', 'tinytext', 'json', 'varbinary', 'longblob', 'mediumblob'
      'string'
    when 'int', 'tinyint', 'smallint'
      'int'
    when 'mediumint', 'bigint'
      'bigint'
    when 'decimal', 'double', 'float'
      "decimal(#{data_type_length}, #{data_type_scale})"
    when 'date', 'datetime', 'timestamp'
      'string'
    else
      raise "Unknown data type: #{data_type}"
    end
  end

  def data_type_name
    data_type.match(DATA_TYPE_REGEX)[:type]
  end

  def data_type_length
    match = data_type.match(DATA_TYPE_REGEX)
    if match && match[:length]
      match[:length].to_i
    else
      nil
    end
  end

  def data_type_scale
    match = data_type.match(DATA_TYPE_REGEX)
    if match && match[:scale]
      match[:scale].to_i
    else
      nil
    end
  end
end
