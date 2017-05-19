class ChangePayDefault < ActiveRecord::Migration[5.0]
  def up
    change_column :events, :pay, :float, :default => 0.0
  end

  def down
    change_column :events, :pay, :integer, :default => 0
  end
end
