class Client < ActiveRecord::Base
  has_many :events
  has_and_belongs_to_many :users , join_table: :clients_users
  has_and_belongs_to_many :brands, join_table: :client_brands
  has_and_belongs_to_many :groups, join_table: :clients_groups
  belongs_to :admin, class_name: 'User', foreign_key: :admin_id
  accepts_nested_attributes_for :brands, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :admin, reject_if: :all_blank, allow_destroy: true
end
