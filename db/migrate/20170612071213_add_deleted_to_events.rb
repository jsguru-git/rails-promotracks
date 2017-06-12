class AddDeletedToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events ,:deleted ,:boolean ,:default => false
  end
end
