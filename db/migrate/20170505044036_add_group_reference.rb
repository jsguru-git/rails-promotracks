class AddGroupReference < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :group, foreign_key: true, index: true
  end
end
