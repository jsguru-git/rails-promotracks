class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :formatted_address
      t.string :address_1
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end
  end
end
