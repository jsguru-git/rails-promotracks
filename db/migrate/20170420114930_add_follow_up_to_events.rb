class AddFollowUpToEvents < ActiveRecord::Migration
  def change
    add_column :events, :follow_up, :string
  end
end
