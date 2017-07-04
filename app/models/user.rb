class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 5..128, :invite_for => 2.weeks
  belongs_to :event
  belongs_to :group
  has_many :user_events
  has_many :events, :through => :user_events
  has_many :brands
  has_many :group_members
  has_many :groups ,:through => :group_members
  has_and_belongs_to_many :clients , join_table: :clients_users
  accepts_nested_attributes_for :clients, reject_if: :all_blank, allow_destroy: true
  mount_uploader :image, ImageUploader

  enum role: [:promo_rep, :super_admin, :client_admin]


  def full_name
    "#{first_name} #{last_name}"
  end

  def self.active_users
    self.where(deleted: false)
  end

  def self.group_members
    promo_rep.where(:group_id => nil).order('first_name')
  end

  def self.promo_representatives
    where(role: 'promo_rep').order('first_name')
  end
end
