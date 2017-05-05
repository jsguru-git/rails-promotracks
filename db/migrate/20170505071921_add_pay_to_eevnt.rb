class AddPayToEevnt < ActiveRecord::Migration[5.0]
  def change
    add_column :events ,:pay ,:integer ,:default=> 0
  end
end
