class AddDeletedToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :deleted, :boolean, :default => false
  end
end
