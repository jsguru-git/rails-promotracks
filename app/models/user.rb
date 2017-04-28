class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 5..128, :invite_for => 2.weeks
  belongs_to :event
  has_many :user_groups
  has_many :groups, :through => :user_groups
  has_many :user_events
  has_many :events, :through => :user_events
  enum role: [:promo_rep, :super_admin, :client_admin]
  has_many :brands
  belongs_to :client
  accepts_nested_attributes_for :client, reject_if: :all_blank, allow_destroy: true


  def full_name
    "#{first_name}  #{last_name}"
  end
end
