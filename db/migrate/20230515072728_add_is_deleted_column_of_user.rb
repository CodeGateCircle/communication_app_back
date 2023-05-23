# AddIsDeletedColumnOfUser
class AddIsDeletedColumnOfUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_deleted, :boolean, default: false, null: false
  end
end
