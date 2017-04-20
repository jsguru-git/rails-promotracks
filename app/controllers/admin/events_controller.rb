class Admin::EventsController < Admin::AdminApplicationController

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
          @event.user_events.new(user_id: user_id, token: SecureRandom.hex[0, 6])
        end
      end
    elsif event_params[:promo_category]=='promo_group'
      @event.group_id= params[:event][:group_id]
    end
    @event.address= Location.new(city: event_params[:address_attributes][:city])
    @event.save
    unless @event.group.nil?
      @event.group.users.each do |user|
        @event.user_events.create(user_id: user.id, token: SecureRandom.hex[0, 6], category: :promo_group)
        # email_data={}
        # email_data[:body] = "Accept the event"
        # email_data[:subject]="New Event :#{@event.id}"
        # to_email = get_email_recipients(event, 'accept')
        # email_data[:user]=get_event(@event)
        # EventMailer.accept_event(to_email, email_data).deliver
      end
    end
    redirect_to admin_events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :type, :promo_category, :start_time, :end_time, :brand_id, :user_ids, address_attributes: [:address_1, :city, :state, :zip, :country])
  end
end
