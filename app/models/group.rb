class Group < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :clients, join_table: :clients_groups
end
