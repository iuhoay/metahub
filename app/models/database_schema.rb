class DatabaseSchema < ApplicationRecord
  belongs_to :database, class_name: "Database", foreign_key: "connect_database_id"
  has_many :tables, class_name: "DatabaseTable", foreign_key: "database_schema_id", dependent: :destroy

  enum column_name_style: %w[lowercase snake_case], _prefix: true, _default: :snake_case

  validates :name, presence: true
  validates :column_name_style, presence: true

  scope :pinned, -> { where.not(pin_at: nil) }

  def ods_schema_name
    (alias_name || name).to_s
  end

  def schema_name
    alias_name || name
  end

  def sync_tables
    database.fetch_all_table(name).each do |row|
      table = tables.find_or_initialize_by(name: row[:name])
      table.comment = row[:comment]
      table.save!
    end
  end

  def generate_jobs
    dir_path = Rails.root.join("tmp", "sql_scripts")
    FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)
    file_path = File.join(dir_path, "#{ods_schema_name}_jobs")
    File.open(file_path, "w") do |file|
      tables.each do |table|
        file.write("#{ods_schema_name}-#{table.name}\n")
      end
    end
  end
end
