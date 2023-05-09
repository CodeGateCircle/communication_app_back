class AddRole < ActiveRecord::Migration[7.0]
  def change
    add_column :workspace_users, :role, :integer, null: false, default: 3
  end
end
