class AddTimeZoneToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations ,:time_zone ,:string
  end
end
