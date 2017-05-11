class UserEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  mount_uploaders :images, ImagesUploader

  enum category: [:promo_rep, :promo_group]
  enum status: [:invited, :accepted, :declined]

end