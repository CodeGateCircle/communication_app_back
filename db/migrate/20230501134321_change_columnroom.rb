class ChangeColumnroom < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :category, :integer

    add_reference :rooms, :category, foreign_key: true
  end
end
