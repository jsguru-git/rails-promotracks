class Event < ActiveRecord::Base

  belongs_to :client
  belongs_to :group
  belongs_to :brand
  has_one :address, class_name: 'Location'
  belongs_to :creator, class_name: 'User', :foreign_key => 'user_id'
  has_many :user_events
  belongs_to :event_type
  has_many :users, :through => :user_events
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  enum promo_category: [:promo_rep, :promo_group]

  def self.active
    self.where(deleted: false)
  end

  def self.active_events
    self.where('(end_time NOTNULL AND end_time > ?)', Time.now- 1.hour)
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

  SORT_BY =
      {
          # 'Date (dsc)' => 'nd',
          # 'Date (asc)' => 'na',
          'Type (asc)' => 'ta',
          'Type (dsc)' => 'td',
          'Area (asc)' => 'aa',
          'Area (dsc)' => 'ad',
      }

  def self.order_events(sort)
    if sort.nil? or sort=='nd'
      order(start_time: :desc)
    elsif sort=='na'
      order(start_time: :asc)
    elsif sort=='td'
      order('event_types.name DESC')
    elsif sort=='ta'
      order('event_types.name ASC')
    elsif sort=='aa'
      order(area: :asc)
    elsif sort=='ad'
      order(area: :desc)
    end
  end

end
