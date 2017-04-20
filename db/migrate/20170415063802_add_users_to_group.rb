class AddUsersToGroup < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.column 'group_id', :integer, index: true, foreign_key: true
      t.column 'user_id', :integer, index: true, foreign_key: true
    end
    add_reference :events, :group, foreign_key: true, index: true
  end
end
