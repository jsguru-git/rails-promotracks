class AddFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :check_in, :datetime
    add_column :events, :check_out, :datetime
    add_column :events, :max_users, :integer, default: 0

  end
end
