class AddEventTypeToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :event_type, index: true, foreign_key: true
  end
end
