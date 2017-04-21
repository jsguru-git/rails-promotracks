class AddAdminToClients < ActiveRecord::Migration
  def change
    add_column :clients, :admin_id, :integer
    add_index :clients, :admin_id
    add_foreign_key :clients, :users, {column: :admin_id}
  end
end
