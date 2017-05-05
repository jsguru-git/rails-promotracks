class AddUnitCostToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands ,:unit_cost ,:float ,:default => 0
  end
end
