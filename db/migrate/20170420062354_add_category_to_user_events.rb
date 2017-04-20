class AddCategoryToUserEvents < ActiveRecord::Migration
  def change
    add_column :user_events, :category, :integer, default: 0
    add_column :user_events, :status, :integer, default: 0
  end
end
