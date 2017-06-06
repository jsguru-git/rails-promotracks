class AddRecapToUserEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events ,:recap ,:boolean
  end
end
