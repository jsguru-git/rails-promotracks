class AddAttendanceToUserEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :attendance, :string
    remove_column :events, :sample, :string

    add_column :user_events, :attendance, :integer
    add_column :user_events, :sample, :integer
    add_column :user_events, :deleted, :boolean, :default => false
    remove_column :user_events, :total_expense, :string
    add_column :user_events, :total_expense, :integer, :default => 0
  end
end
