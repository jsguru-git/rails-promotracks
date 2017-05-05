class Event < ActiveRecord::Base
  enum promo_category: [:promo_rep, :promo_group]
  belongs_to :client
  belongs_to :group
  belongs_to :brand
  has_one :address, class_name: 'Location'
  belongs_to :creator, class_name: 'User', :foreign_key => 'user_id'
  has_many :user_events
  belongs_to :event_type
  has_many :users, :through => :user_events
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true


  def self.active_events
    self.where('(end_time NOTNULL AND end_time > ?)', Time.now)
        .where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil})
  end


  def self.checkedin_events
    self.where('(end_time NOTNULL AND end_time > ?)', Time.now)
        .where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil}).where.not(:user_events => {:check_in => nil})
  end

  def self.expired_events
    self.where('(end_time NOTNULL AND end_time < ?)', Time.now)
        .where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil}).where.not(:user_events => {:check_in => nil})
  end
end
