class AddPaymentToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients ,:payment ,:float ,:default => 0.0
  end
end
