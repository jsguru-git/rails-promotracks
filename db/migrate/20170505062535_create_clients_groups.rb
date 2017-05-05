class CreateClientsGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :clients_groups, :id => false do |t|
      t.integer :client_id
      t.integer :group_id
    end
  end
end
