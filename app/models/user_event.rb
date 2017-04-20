class UserEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  enum category: [:promo_rep, :promo_group]
end