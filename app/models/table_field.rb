class TableField < ApplicationRecord
  belongs_to :database_table

  DATA_TYPE_REGEX = /(?<type>\w+)\(?(?<length>\d+)?,?(\d+)?/

  def to_hive_column
    "`#{field}` #{get_hive_type}"
  end

  def get_hive_type
    case data_type_name
    when 'varchar', 'char', 'text', 'longtext', 'mediumtext', 'tinytext', 'json'
      'string'
    when 'int', 'tinyint', 'smallint', 'mediumint', 'bigint'
      'bigint'
    when 'float', 'double', 'decimal'
      'double'
    when 'date', 'datetime', 'timestamp'
      'timestamp'
    else
      'string'
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
end
