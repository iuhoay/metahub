class TableField < ApplicationRecord
  belongs_to :database_table

  DATA_TYPE_REGEX = /(?<type>\w+)\(?(?<length>\d+)?,?((?<scale>\d+))?/

  def to_hive_column
    "`#{field}` #{get_hive_type}"
  end

  def get_hive_type
    case data_type_name
    when 'varchar', 'char', 'text', 'longtext', 'mediumtext', 'tinytext', 'json'
      'string'
    when 'int', 'tinyint', 'smallint'
      'int'
    when 'mediumint', 'bigint'
      'bigint'
    when 'decimal'
      "decimal(#{data_type_length}, #{data_type_scale})"
    when 'date', 'datetime', 'timestamp'
      'timestamp'
    else
      raise "Unknown data type: #{data_type_name}"
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
