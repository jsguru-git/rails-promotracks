class AddGroupMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_members do |t|
      t.column 'group_id', :integer, index: true, foreign_key: true
      t.column 'user_id', :integer, index: true, foreign_key: true
    end
  end
end
