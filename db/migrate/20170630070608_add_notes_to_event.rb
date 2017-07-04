class AddNotesToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events ,:notes ,:string
  end
end
