class AddDefaultsToUserEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :user_events, :attendance, :integer,:default => 0
    change_column :user_events, :sample, :integer ,:default => 0
  end
end
