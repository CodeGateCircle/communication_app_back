class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.string :description
      t.string :iconImageUrl
      t.string :coverImageUrl

      t.timestamps
    end
  end
end
