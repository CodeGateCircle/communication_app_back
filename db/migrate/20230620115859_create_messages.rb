class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true

      t.text :content, null: false

      t.timestamps
    end
  end
end
