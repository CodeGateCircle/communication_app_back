# unique columns
class SetUniqueColumns < ActiveRecord::Migration[7.0]
  def change
    add_index :workspace_users, [:workspace_id, :user_id], unique: true
  end
end
