class AddEventsToUser < ActiveRecord::Migration
  def change
    add_reference :events, :user, index: true, foreign_key: true
    add_reference :brands, :user, index: true, foreign_key: true
    add_reference :events, :brand, index: true, foreign_key: true
    add_reference :locations, :event, index: true, foreign_key: true
  end
end
