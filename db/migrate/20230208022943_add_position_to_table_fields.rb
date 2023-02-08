class AddPositionToTableFields < ActiveRecord::Migration[7.0]
  def change
    add_column :table_fields, :position, :integer

    TableField.all.group_by(&:database_table_id).each do |table_id, fields|
      fields.each_with_index do |field, index|
        field.update_column(:position, index)
      end
    end
  end
end
