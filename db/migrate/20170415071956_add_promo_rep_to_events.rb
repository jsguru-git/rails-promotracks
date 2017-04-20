class AddPromoRepToEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.column 'event_id', :integer, index: true, foreign_key: true
      t.column 'user_id', :integer, index: true, foreign_key: true
      t.column 'token', :string
    end
  end
end
