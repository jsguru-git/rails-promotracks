class RemoveDefaultFromRecommended < ActiveRecord::Migration[5.0]
  def up
    change_column :user_events, :recommended, :boolean, :default => nil
  end

  def down
    change_column :user_events, :recommended, :boolean, :default => false
  end
end
