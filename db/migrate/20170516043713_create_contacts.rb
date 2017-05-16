class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.jsonb "details", default: {}
      t.timestamps
    end
  end
end
