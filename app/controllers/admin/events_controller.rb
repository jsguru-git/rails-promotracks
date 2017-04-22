require 'platform/email_helper'
class Admin::EventsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    @events=@current_client.events
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
      unless params[:event][:user_ids].delete_if { |x| x.empty? }.nil?
        params[:event][:user_ids].delete_if { |x| x.empty? }.each do |user_id|
          @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6], status: :accepted)
        end
      end
    elsif event_params[:promo_category]=='promo_group'
      @event.group_id= params[:event][:group_id]
    end
    @event.save
    email_data={}
    email_data[:body] = "Please find below the event details"
    email_data[:subject]="#{@event.name} :#{@event.id}"
    email_data[:event]=get_event(@event)
    unless @event.group.nil?
      @event.group.users.each do |user|
        token=SecureRandom.hex[0, 6]
        @event.user_events.create(user_id: user.id, token: token, category: :promo_group)
        EventMailer.accept_event(user.email, email_data, token).deliver
      end
    end
    redirect_to admin_events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :event_type_id, :promo_category, :start_time, :end_time, :brand_id, :user_ids, :max_users, address_attributes: [:address_1, :city, :state, :zip, :country, :latitude, :longitude, :formatted_address])
  end
end
