class AddcategoryToGroup < ActiveRecord::Migration
  def change
    add_column :events, :promo_category, :integer
  end
end
