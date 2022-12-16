class AddCommentNameToDatabaseSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :database_schemas, :comment_name, :string
  end
end
