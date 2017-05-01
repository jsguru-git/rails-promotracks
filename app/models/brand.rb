class Brand < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_and_belongs_to_many :clients, join_table: :client_brands

  def self.active_brands
    where(deleted: false)
  end
end
