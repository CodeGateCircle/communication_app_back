class CreateInvitationTable < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :type
      t.integer :this_id
      t.string :plain_text
      t.string :password_digest
      t.boolean :is_deleted, default: false
    end
  end
end
