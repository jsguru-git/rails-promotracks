class Api::V1::EventsController < Api::V1::ApiApplicationController


  def index
    @events = current_user.events.active.active_events.includes(:user_events).where(:user_events => {:user_id => current_user.id})
  end

  def update
    @event=current_user.events.find(params[:id])
    @user_event=UserEvent.where(user_id: current_user.id, event_id: @event.id, status: :accepted).first
    # if @event.promo_rep?
    #   @user_event=UserEvent.where(user_id: current_user.id, event_id: @event.id, :category => 'promo_rep').first
    # elsif @event.promo_group?
    #   @user_event=UserEvent.where(user_id: current_user.id, event_id: @event.id, :category => 'promo_group').first
    # end

    unless user_event_params[:check_in].nil?
      if user_event_params[:check_in] < (@event.start_time-1.hour)
        render 'global/error', :locals => {:code => 701, :message => 'you can checkin only before an hour'}
        return
      end
      if current_user.events.active.checkedin_events.includes(:user_events).where(:user_events => {:user_id => current_user.id}).size>0
        render 'global/error', :locals => {:code => 701, :message => 'can check in only one event at a time'}
        return
      end
    end
    if @user_event.update_attributes(user_event_params)
      if (@event.end_time+1.hour).to_i  < Time.now.utc.to_i and !user_event_params[:check_out].nil?
        @user_event.update_attribute(:check_out,@event.end_time + 1.hour)
      end
      if params[:user_event][:images].nil?
        render :show
      else
        success, error, images= add_images(params[:user_event][:images], @user_event)
        if success
          @user_event.update_attribute(:images, images) unless images.nil?
          render :show
        else
          render 'global/error', :locals => {:code => 701, :message => error}
          return
        end
      end
    else
      render 'global/error', :locals => {:code => 701, :message => @user_event.errors.full_messages.join(', ')}
    end
  end

  def active
    @events = current_user.events.active.checkedin_events.includes(:user_events).where(:user_events => {:user_id => current_user.id})
    render :index
  end

  def expired
    @events = current_user.events.active.expired_events.includes(:user_events).where(:user_events => {:user_id => current_user.id}).order('end_time desc')
    render :index
  end

  private


  def user_event_params
    params.require(:user_event).permit(:notes, :total_expense, :check_in, :check_out, :images, :follow_up, :recommended, :recap,:attendance, :sample)
  end


end