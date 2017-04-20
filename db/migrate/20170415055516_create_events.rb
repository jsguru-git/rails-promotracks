class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :type
      t.datetime :start_time
      t.datetime :end_time
      t.string :area
      t.string :attendance
      t.integer :sample
      t.float :product_cost
      t.float :total_expense
      t.string :notes
      t.text :images, default: [], array: true
      t.timestamps null: false
    end
  end
end
