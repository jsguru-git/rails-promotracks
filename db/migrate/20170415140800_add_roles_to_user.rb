class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, :default => 0
  end
end
