class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces, id: :string do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.string :iconImageUrl, null: true
      t.string :coverImageUrl, null: true

      t.timestamps
    end
  end
end
