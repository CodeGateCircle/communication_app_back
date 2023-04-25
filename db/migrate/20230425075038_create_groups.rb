class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.string :icon_image_url, null: true
      t.references :workspace, foreign_key: true

      t.timestamps
    end
  end
end
