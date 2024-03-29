# workspace
class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.string :icon_image_url, null: true
      t.string :cover_image_url, null: true

      t.timestamps
    end
  end
end
