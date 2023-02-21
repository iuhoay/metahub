class DatabaseTable < ApplicationRecord
  belongs_to :database_schema, counter_cache: true
  has_many :table_fields, -> { order(position: :asc) }, dependent: :destroy

  def sync_fields
    database_schema.database.fetch_all_column(database_schema.name, name).each do |field|
      table_field = table_fields.find_or_initialize_by(field: field[:name])
      table_field.data_type = field[:type]
      table_field.key = field[:key]
      table_field.nullable = field[:nullable]
      table_field.default_value = field[:default]
      table_field.field_extra = field[:extra]
      table_field.comment = field[:comment]
      table_field.save!
    end
  end

  def ods_table_name
    "#{database_schema.ods_schema_name}.ods_#{table_name_all_dd}"
  end

  def generate_sql_script
    dir_path = Rails.root.join('tmp', 'sql_scripts', 'init_ods_db', database_schema.schema_name)
    FileUtils.mkdir_p(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "ods_#{table_name_all_dd}.sql")
    File.open(file_path, 'w') do |file|
      file.write(create_hive_table_init_script)
    end
  end

  def generate_datax_script
    dir_path = Rails.root.join('tmp', 'sql_scripts', 'data_fetch_outer_source', database_schema.schema_name)
    FileUtils.mkdir_p(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "ods_#{table_name_all_dd}.json")
    File.open(file_path, 'w') do |file|
      file.write(create_datax_script)
    end
  end

  def generate_dwd_job
    dir_path = Rails.root.join('tmp', 'sql_scripts', 'dwd_job', database_schema.schema_name)
    FileUtils.mkdir_p(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "dwd_#{table_name_all_dd}.job")
    File.open(file_path, 'w') do |file|
      file.write(create_dwd_job_file)
    end
  end

  def table_name_all_dd
    if database_schema.hive_table_prefix.present?
      "#{database_schema.hive_table_prefix}_#{name}_all_dd"
    else
      "#{name}_all_dd"
    end
  end

  private

  def create_dwd_job_file
    # type=command
    # command=sh ../../../utilities/shell/update_data_common.sh db_rent/dwd/dwd_rent_order_change_log_all_dd.sql ${start_datetime} ${end_datetime}
    # dependencies=
    script = "type=command\n"
    script += "command=sh ../../../utilities/shell/update_data_common.sh #{database_schema.schema_name}/dwd/dwd_#{table_name_all_dd}.sql ${start_datetime} ${end_datetime}\n"
    script += "dependencies=\n"
    script
  end

  def create_hive_table_init_script
    script = "CREATE EXTERNAL TABLE IF NOT EXISTS #{ods_table_name}\n"
    script += "(\n"
    table_fields.each_with_index do |field, index|
      script += "  #{field.to_hive_column}"
      script += " COMMENT '#{field.comment}'" if field.comment.present?
      if (index + 1) < table_fields.size
        script += ",\n"
      else
        script += "\n)\n"
      end
    end
    script += "COMMENT '#{database_schema.comment_name}#{comment}'\n" if comment.present?
    script += "PARTITIONED BY (`ds` string comment '分区')\n"
    script += "ROW FORMAT DELIMITED\n"
    script += "NULL DEFINED AS \"\"\n"
    script += "STORED AS ORC\n"
    script += "LOCATION 'hdfs://qncluster/data/warehouse/tablespace/external/hive/#{database_schema.alias_name}.db/ods_#{table_name_all_dd}'\n"
    script += 'TBLPROPERTIES ("auto.purge"="true");'
    script
  end

  def create_hive_table_script
    script = "CREATE TABLE IF NOT EXISTS #{ods_table_name}\n"
    script += "(\n"
    script += "    id int\n"
    script += ") partitioned by (`ds` string comment '日期')\n"
    script += "    ROW FORMAT DELIMITED\n"
    script += "        FIELDS TERMINATED BY '\\001'\n"
    script += "        LINES TERMINATED BY '\\n'\n"
    script += "    STORED AS ORC;\n\n"

    if comment.present?
      script += "ALTER TABLE #{ods_table_name}\n"
      script += "    SET TBLPROPERTIES('COMMENT'='#{comment}');\n\n"
    end

    script += "ALTER TABLE #{ods_table_name}\n"
    script += "    REPLACE COLUMNS (\n"
    table_fields.each_with_index do |field, index|
      script += "        #{field.to_hive_column}"
      script += " COMMENT '#{field.comment}'" if field.comment.present?
      if (index + 1) < table_fields.size
        script += ",\n"
      else
        script += ");"
      end
    end
    script
  end

  def create_datax_script
    json_builder = Jbuilder.new do |json|
      json.job do
        json.setting do
          json.speed do
            json.channel(1)
          end
          json.errorLimit do
            json.record(0)
            json.percentage(0.02)
          end
        end
        json.content do
          json.child! do
            json.reader do
              json.name('mysqlreader')
              json.parameter do
                json.username("${username}")
                json.password("${password}")
                json.column(table_fields.map(&:field))
                json.where("create_time < '${curr_datetime}'")
                json.connection do
                  json.child! do
                    json.table([name])
                    json.jdbcUrl(['jdbc:mysql://${src_db_ip}:${src_db_port}/${src_db_name}?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false&useSSL=false'])
                  end
                end
                json.splitPk('id')
              end
            end
            json.writer do
              json.name('hdfswriter')
              json.parameter do
                json.defaultFS("hdfs://nameservice1")
                json.hadoopConfig do
                  json.set! 'dfs.nameservices', 'nameservice1'
                  json.set! 'dfs.ha.namenodes.nameservice1', 'namenode1,namenode2'
                  json.set! 'dfs.namenode.rpc-address.nameservice1.namenode1', 'hadoop-master-001:8020'
                  json.set! 'dfs.namenode.rpc-address.nameservice1.namenode2', 'hadoop-master-002:8020'
                  json.set! 'dfs.client.failover.proxy.provider.nameservice1', 'org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider'
                end
                json.fileType('orc')
                json.path("${hive_default_data_dir}/#{database_schema.ods_schema_name}.db/#{name}/ds=${yesterday}")
                json.path("/data/warehouse/tablespace/external/hive/#{database_schema.alias_name}.db/ods_#{table_name_all_dd}/ds=${yesterday}")
                json.fileName("#{database_schema.ods_schema_name}-ods_#{table_name_all_dd}")
                json.writeMode('append')
                json.fieldDelimiter("\u0001")
                json.column table_fields do |field|
                  json.name(field.to_hive_column_name)
                  json.type(field.get_hive_type_on_datax)
                end
              end
            end
          end
        end
      end
    end

    json_builder.target!
  end
end
