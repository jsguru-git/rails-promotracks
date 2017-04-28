require 'platform/email_helper'
class Admin::EventsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    if params[:search]
      if params[:search_type]=='promo_group'
        @events=@current_client.events.where(:group_id => params[:promo_id])
      elsif params[:search_type]=='promo_rep'
        @events=@current_client.events.joins(:users).where("users.id IN (?)", params[:promo_id])
      end
    else
      @events=@current_client.events
    end
  end

  def new
    @event=@current_client.events.new
    @address=@event.build_address
    @promo_reps=@current_client.users.where(role: 'promo_rep')
  end

  def create
    @event=@current_client.events.new(event_params)
    @event.creator= current_user
    @event.start_time= DateTime.strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p')
    @event.end_time= DateTime.strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p')
    if event_params[:promo_category]=='promo_rep'
      @event.promo_category= :promo_rep
      unless params[:event][:user_ids].delete_if { |x| x.empty? }.nil?
        params[:event][:user_ids].delete_if { |x| x.empty? }.each do |user_id|
          @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
        end
      end
    elsif event_params[:promo_category]=='promo_group'
      @event.promo_category= :promo_group
      @event.group_id= params[:event][:group_id] unless params[:event][:group_id].nil?
    end
    @event.save
    email_data={}
    email_data[:body] = "Please find below the event details"
    email_data[:subject]="#{@event.name} :#{@event.id}"
    email_data[:event]=get_event(@event)
    unless @event.group_id.nil?
      @event.group.users.each do |user|
        token=SecureRandom.hex[0, 6]
        @event.user_events.create(user_id: user.id, token: token, category: :promo_group)
        # EventMailer.accept_event(user.email, email_data, token).deliver
      end
    end
    if @event.promo_rep?
      @event.users.each do |user|
        # EventMailer.accept_event(user.email, email_data).deliver
      end
    end
    redirect_to admin_events_path
  end

  def edit
    @event=Event.find(params[:id])
    @address=@event.address
    @promo_reps=@current_client.users.where(role: 'promo_rep')
  end

  def update
    @event=Event.find(params[:id])
    if @event.update_attributes(event_params.except(:promo_category))
      @event.update_attribute(:start_time, DateTime.strptime(event_params[:start_time], '%m/%d/%Y %I:%M %p')) unless event_params[:start_time].nil?
      @event.update_attribute(:end_time, DateTime.strptime(event_params[:end_time], '%m/%d/%Y %I:%M %p')) unless event_params[:end_time].nil?
      if event_params[:promo_category]=='promo_rep' and @event.promo_category_was=='promo_rep'
        unless params[:event][:user_ids].delete_if { |x| x.empty? }.nil?
          @event.update_attribute(:promo_category, :promo_rep)
          delete_users=@event.user_ids-(params[:event][:user_ids].map(&:to_i))
          delete_users.each do |del_user|
            @event.user_events.where(user_id: del_user).first.delete
          end
          create_users=(params[:event][:user_ids].map(&:to_i))-delete_users
          create_users.each do |user_id|
            if @event.user_ids.exclude? user_id
              @event.user_events.create(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
            end
          end
        end
      elsif event_params[:promo_category]=='promo_group' and @event.promo_category_was=='promo_group'
        unless event_params[:group_id].nil?
          @event.update_attribute(:promo_category, :promo_group)
          if @event.group_id_was!=event_params[:group_id].to_i
            UserEvent.where(:event_id => @event.id).delete_all
            @event.update_attribute(:group_id, event_params[:group_id])
            email_data={}
            email_data[:body] = "Please find below the event details"
            email_data[:subject]="#{@event.name} :#{@event.id}"
            email_data[:event]=get_event(@event)
            @event.group.users.each do |user|
              token=SecureRandom.hex[0, 6]
              @event.user_events.create(user_id: user.id, token: token, category: :promo_group)
              # EventMailer.accept_event(user.email, email_data, token).deliver
            end
          end
        end
      elsif event_params[:promo_category]=='promo_rep' and @event.promo_category_was=='promo_group'
        @event.update_attribute(:group_id, nil)
        UserEvent.where(:event_id => @event.id).delete_all
        @event.update_attribute(:promo_category, :promo_rep)
        unless params[:event][:user_ids].delete_if { |x| x.empty? }.nil?
          params[:event][:user_ids].delete_if { |x| x.empty? }.each do |user_id|
            @event.user_events.create(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
          end
        end
      elsif event_params[:promo_category]=='promo_group' and @event.promo_category_was=='promo_rep'
        unless event_params[:group_id].nil?
          @event.update_attribute(:promo_category, :promo_group)
          UserEvent.where(:event_id => @event.id).delete_all
          @event.update_attribute(:group_id, event_params[:group_id])
          email_data={}
          email_data[:body] = "Please find below the event details"
          email_data[:subject]="#{@event.name} :#{@event.id}"
          email_data[:event]=get_event(@event)
          @event.group.users.each do |user|
            token=SecureRandom.hex[0, 6]
            @event.user_events.create(user_id: user.id, token: token, category: :promo_group)
            # EventMailer.accept_event(user.email, email_data, token).deliver
          end
        end
      end
      redirect_to admin_events_path
    else
      flash[:error]= @event.errors.full_messages.join(',')
      redirect_to :back
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :event_type_id, :promo_category, :start_time, :end_time, :brand_id, :user_ids, :group_id, :max_users, address_attributes: [:address_1, :city, :state, :zip, :country, :latitude, :longitude, :formatted_address])
  end
end
