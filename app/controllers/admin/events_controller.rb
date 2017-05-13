require 'platform/email_helper'
class Admin::EventsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    if params[:search]
      unless params[:promo_id].blank?
        if params[:search_type]=='promo_group'
          @events=@current_client.events.where(:group_id => params[:promo_id]).order('updated_at desc').collect { |u| u }
        elsif params[:search_type]=='promo_rep'
          @events=@current_client.events.joins(:users).where("users.id IN (?)", params[:promo_id]).order('updated_at desc').collect { |u| u }
        end
        unless @events.kind_of?(Array)
          @events = @events.page(params[:page]).per(10)
        else
          @events = Kaminari.paginate_array(@events.uniq).page(params[:page]).per(10)
        end
      end
    else
      @events=@current_client.events.page(params[:page]).per(20).order('updated_at desc')
    end
  end

  def new
    @event=@current_client.events.new
    @address=@event.build_address
    @promo_reps=User.promo_representatives
  end

  def create
    @event=@current_client.events.new(event_params)
    if event_params[:group_id].blank? and params[:event][:user_ids].reject(&:blank?).blank?
      flash[:error]= "Either Promo Rep or Group should be selected"
      redirect_to :back
      return
    end
    @event.creator= current_user
    @event.start_time= Time.zone.strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p')
    @event.end_time= Time.zone.strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p')
    params[:event][:user_ids].reject(&:blank?).each do |user_id|
      user=User.find(user_id)
      @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
      @current_client.users << user
    end
    unless params[:event][:group_id].blank?
      group=Group.find(params[:event][:group_id])
      group.users.each do |user|
        token=SecureRandom.hex[0, 6]
        @event.user_events.new(user_id: user.id, token: token, category: :promo_group)
      end
      @current_client.groups << group
    end
    if @event.save
      @current_client.save
      EventJob.perform_later('event', @event, @event.user_ids)
      redirect_to admin_events_path
    else
      flash[:error]=@event.errors.full_messages.join(', ')
      redirect_to :back
    end
  end

  def edit
    @event=Event.find(params[:id])
    @address=@event.address
    @promo_reps=User.promo_representatives
  end

  def show
    @event = Event.find(params[:id])
  end
  def update
    reps = []
    group_email=false
    rep_email=false
    @event=Event.find(params[:id])
    if event_params[:group_id].blank? and params[:event][:user_ids].blank?
      flash[:error]= "Either Promo Rep or Group should be selected"
      redirect_to :back
      return
    end
    @event.assign_attributes(event_params)
    if @event.valid?
      @event.start_time=Time.zone.strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p') unless event_params[:start_time].nil?
      @event.end_time=Time.zone.strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p') unless event_params[:end_time].nil?
      if @event.group_id_changed?
        group_email=true
        group=Group.find(@event.group_id_was)
        group.users.each do |user|
          @event.user_events.where(:user_id => user.id).first.delete
        end
        @event.group.users.each do |user|
          token=SecureRandom.hex[0, 6]
          @event.user_events.new(user_id: user.id, token: token, category: :promo_group)
        end
      end
      rep_ids=@event.user_events.where(:category => 0).map(&:user_id).reject(&:blank?)
      new_rep_ids=params[:event][:user_ids].reject(&:blank?).map(&:to_i)
      unless (rep_ids - new_rep_ids && new_rep_ids - rep_ids).empty?
        unless new_rep_ids.nil?
          delete_users=rep_ids-(new_rep_ids)
          delete_users.each do |del_user|
            @event.user_events.where(user_id: del_user).first.delete
          end
          create_users=new_rep_ids-delete_users
          rep_email=true if create_users.any?
          create_users.each do |user_id|
            if @event.user_ids.exclude? user_id
              rep=User.find(user_id)
              reps << rep
              @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
            end
          end
        end
      end
      @event.save!
      if group_email
        EventJob.perform_later('event', @event, @event.group.user_ids)
      end
      if rep_email
        EventJob.perform_later('event', @event, reps)
      end
      redirect_to admin_events_path
    else
      flash[:error]=@event.errors.full_messages.join(', ')
      redirect_to :back
    end
  end
  private
  def event_params
    params.require(:event).permit(:name, :event_type_id, :start_time, :end_time, :brand_id, :user_ids, :group_id, :max_users, :pay, :area, address_attributes: [:address_1, :city, :state, :zip, :country, :latitude, :longitude, :formatted_address])
  end
end
