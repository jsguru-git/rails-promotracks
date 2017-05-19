class ChnageDefaultForTotalExpense < ActiveRecord::Migration[5.0]
  def up
    change_column :user_events, :total_expense, :float, :default => 0.0
  end

  def down
    change_column :user_events, :total_expense, :integer, :default => 0
  end
end
