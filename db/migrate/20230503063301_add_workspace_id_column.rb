class AddWorkspaceIdColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :workspace_id, :integer
    # add_reference :categories, :workspace, foreign_key: true
    add_foreign_key :categories, :workspaces, columns: :workspace_id
  end
end