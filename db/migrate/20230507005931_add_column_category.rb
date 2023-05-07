# AddColumnCategory
class AddColumnCategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :workspace, foreign_key: true
  end
end
