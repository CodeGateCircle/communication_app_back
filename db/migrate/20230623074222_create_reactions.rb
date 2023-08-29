class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :message, foreign_key: true
      t.references :user, foreign_key: true

      t.string :name, null: false

      t.timestamps
    end
  end
end
