class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 5..128
  belongs_to :event
  has_many :user_groups
  has_many :groups, :through => :user_groups
  has_many :user_events
  has_many :events, :through => :user_events

  enum role: [:promo_rep, :super_admin, :client_admin]
  has_many :brands
  belongs_to :client


  def full_name
    "#{first_name}" "#{last_name}"
  end
end
