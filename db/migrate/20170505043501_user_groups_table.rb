class UserGroupsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_groups do |t|
      t.column 'group_id', :integer, index: true, foreign_key: true
      t.column 'user_id', :integer, index: true, foreign_key: true
    end
  end
end
