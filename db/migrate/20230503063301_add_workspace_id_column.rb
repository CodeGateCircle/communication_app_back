class AddWorkspaceIdColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :workspace_id, :integer
  end
end
