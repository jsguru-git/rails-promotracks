class AddReferencesToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :client, index: true, foreign_key: true
    add_reference :events, :client, index: true, foreign_key: true
  end
end
