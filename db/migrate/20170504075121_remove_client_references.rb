class RemoveClientReferences < ActiveRecord::Migration[5.0]
  def change
    remove_reference :users, :client, index: true, foreign_key: true
    remove_reference :groups, :client, index: true, foreign_key: true
  end
end
