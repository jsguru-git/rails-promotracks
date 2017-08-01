require 'platform/email_helper'
class Admin::EventsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    if params[:search]
      unless params[:promo_id].blank?
        if params[:search_type]=='promo_group'
          @events=@current_client.events.active.where(:group_id => params[:promo_id]).order('updated_at desc').collect { |u| u }
        elsif params[:search_type]=='promo_rep'
          @events=@current_client.events.active.joins(:users).where("users.id IN (?)", params[:promo_id]).order('updated_at desc').collect { |u| u }
        end
        unless @events.kind_of?(Array)
          @events = @events.page(params[:page]).per(10)
        else
          @events = Kaminari.paginate_array(@events.uniq).page(params[:page]).per(10)
        end
      end
    else
      @events=@current_client.events.active.page(params[:page]).per(20).order('updated_at desc')
    end
    respond_to do |format|
      format.html {
      }
      format.js {
        html = render_to_string :partial => 'admin/events/events', layout: false, :locals => {:events => @events}
        html_footer = render_to_string :partial => 'admin/events/footer', layout: false, :locals => {:events => @events}
        render :json => {:success => true, :html => html, :footer => html_footer}
      }
    end
  end

  def new
    @event=@current_client.events.new
    @address=@event.build_address
    @promo_reps=@current_client.users.promo_representatives
  end

  def create
    @promo_reps=@current_client.users.promo_representatives
    @event=@current_client.events.new(event_params)
    @event.address.city = event_params[:address_attributes][:city] unless event_params[:address_attributes][:formatted_address].blank?
    user_ids=params[:event][:user_ids].reject(&:blank?).map(&:to_i)
    if event_params[:group_id].blank? and user_ids.blank?
      flash[:error]= "Either Direct Sourced or Group should be selected"
      render :new
      return
    end
    @event.creator= current_user
    user_ids.each do |user_id|
      user=User.find(user_id)
      @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
    end
    unless params[:event][:group_id].blank?
      group=Group.find(params[:event][:group_id])
      group.users.each do |user|
        next if user_ids.include? user.id
        @event.user_events.new(user_id: user.id, token: SecureRandom.hex[0, 6], category: :promo_group)
      end
    end
    if @event.save
      @event.start_time = Time.find_zone(@event.address.time_zone).strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p') unless event_params[:start_time].blank?
      @event.end_time = Time.find_zone(@event.address.time_zone).strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p') unless event_params[:end_time].blank?
      @event.save
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
    @promo_reps=@current_client.users.promo_representatives
  end

  def show
    @event = Event.find(params[:id])
  end
  def update
    reps = []
    group_email=false
    rep_email=false
    @event=Event.find(params[:id])
    user_ids=params[:event][:user_ids].reject(&:blank?).map(&:to_i)
    if event_params[:group_id].blank? and user_ids.blank?
      flash[:error]= "Either Direct Sourced or Group should be selected"
      redirect_to :back
      return
    end
    @event.assign_attributes(event_params)
    if @event.valid?
      if @event.address.city_changed? and params[:selected]=="false"
        @event.address.city = event_params[:address_attributes][:city]
        @event.address.update(address_1: nil,state: nil ,country: nil ,formatted_address: nil,zip: nil,longitude: nil,latitude: nil)
      end
      if @event.group_id_changed?
        group_email=true
        group=Group.find(@event.group_id_was)
        group.users.each do |user|
          @event.user_events.where(:user_id => user.id).first.delete if @event.user_events.where(:user_id => user.id).exists?
        end
        @event.group.users.each do |user|
          next if user_ids.include? user.id
          @event.user_events.new(user_id: user.id, token: SecureRandom.hex[0, 6], category: :promo_group)
        end
      end
      rep_ids=@event.user_events.where(:category => 0).map(&:user_id).reject(&:blank?)
      new_rep_ids=user_ids
      unless (new_rep_ids & rep_ids).empty?
        unless new_rep_ids.nil?
          delete_users=rep_ids-(new_rep_ids)
          delete_users.each do |del_user|
            @event.user_events.where(user_id: del_user).first.delete
          end
          create_users=new_rep_ids-delete_users
          rep_email=true if create_users.any?
          create_users.each do |user_id|
            if @event.user_events.where(:category => 0).collect { |c| c[:user_id] }.exclude? user_id
              # next if @event.group_id and @event.group.user_ids.include? user_id
              rep=User.find(user_id)
              reps << rep
              @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
            end
          end
        end
      end
      @event.save!
      @event.start_time = Time.find_zone(@event.address.time_zone).strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p') unless event_params[:start_time].blank?
      @event.end_time = Time.find_zone(@event.address.time_zone).strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p') unless event_params[:end_time].blank?
      @event.save
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
    params.require(:event).permit(:name, :event_type_id,:notes, :start_time, :end_time, :brand_id, :user_ids, :group_id, :max_users, :pay, :area, address_attributes: [:address_1, :city, :state, :zip, :country, :latitude, :longitude, :formatted_address ,:time_zone])
  end
end
