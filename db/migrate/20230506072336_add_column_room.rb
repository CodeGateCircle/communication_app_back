# AddColumnRoom
class AddColumnRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :is_deleted, :boolean, default: false, null: false
  end
end
