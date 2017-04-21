class AddFieldsToUserEvent < ActiveRecord::Migration
  def change
    remove_column :events, :notes, :string
    remove_column :events, :total_expense, :float
    remove_column :events, :check_in, :datetime
    remove_column :events, :check_out, :datetime
    remove_column :events, :images, :text, default: [], array: true
    remove_column :events, :follow_up, :string
    add_column :user_events, :notes, :string
    add_column :user_events, :total_expense, :string
    add_column :user_events, :recommended, :boolean, :default => false
    add_column :user_events, :check_in, :datetime
    add_column :user_events, :check_out, :datetime
    add_column :user_events, :images, :text, default: [], array: true
    add_column :user_events, :follow_up, :string
  end

end
