class CreateClientsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :clients_users ,:id=>false do |t|
      t.integer :client_id
      t.integer :user_id
    end
  end
end
