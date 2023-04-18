# workspace_user
class CreateWorkspaceUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :workspace_users do |t|
      t.string :workspace_id
      t.string :uid

      t.timestamps
    end
  end
end
