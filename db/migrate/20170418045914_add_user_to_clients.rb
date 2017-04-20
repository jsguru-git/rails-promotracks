class AddUserToClients < ActiveRecord::Migration
  def change
    add_reference :users, :client, index: true, foreign_key: true
    create_table :client_brands, id: false do |t|
      t.column 'client_id', :integer, index: true, foreign_key: true
      t.column 'brand_id', :integer, index: true, foreign_key: true
    end
  end
end
