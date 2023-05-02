# room
class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.integer :category, default: 0
      t.references :workspace, foreign_key: true

      t.timestamps
    end
  end
end
