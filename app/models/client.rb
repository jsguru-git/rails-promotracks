class Client < ActiveRecord::Base
  has_many :events
  has_many :groups
  has_many :users
  has_and_belongs_to_many :brands, join_table: :client_brands
  belongs_to :admin, class_name: 'User', foreign_key: :admin_id
  accepts_nested_attributes_for :admin, reject_if: :all_blank, allow_destroy: true
  validates_length_of :phone, :minimum => 15, :maximum => 15
end
