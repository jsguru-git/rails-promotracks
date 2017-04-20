class Client < ActiveRecord::Base
  has_many :events
  has_many :groups
  has_many :users
  has_and_belongs_to_many :brands, join_table: :client_brands
end
