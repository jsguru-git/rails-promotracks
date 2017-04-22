class AddDefaultToPromoCategory < ActiveRecord::Migration
  def change
    change_column :events, :promo_category, :integer, default: 0
  end
end
