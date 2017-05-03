class Api::V1::EventsController < Api::V1::ApiApplicationController


  def index
    @events = current_user.events.includes(:user_events).where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil}).where('(end_time ISNULL AND start_time >= ?) or (end_time NOTNULL AND end_time >= ?)', Time.now, Time.now)
  end

  def update
    @event=current_user.events.find(params[:id])
    if @event.promo_rep?
      @user_event=UserEvent.where(user_id: current_user.id, event_id: @event.id, :category => 0).first
    elsif @event.promo_group?
      @user_event=UserEvent.where(user_id: current_user.id, event_id: @event.id, :category => 1).first
    end

    unless user_event_params[:check_in].nil?
      if user_event_params[:check_in] < (@event.start_time-1.hour)
        render 'global/error', :locals => {:code => 701, :message => 'cant check in before the event starts'}
        return
      end
      if current_user.events.includes(:user_events).where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil}).where.not(:user_events => {:check_in => nil}).size>0
        render 'global/error', :locals => {:code => 701, :message => 'can check in only one event at a time'}
        return
      end
    end

    if @user_event.update_attributes(user_event_params)
      if params[:user_event][:images].nil?
        render :show
      else
        success, error= add_images(params[:user_event][:images], @user_event)
        if success
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
    @events = current_user.events.includes(:user_events).where(:user_events => {:status => UserEvent::statuses[:accepted], :check_out => nil}).where.not(:user_events => {:check_in => nil}).where('(end_time ISNULL AND start_time >= ?) or (end_time NOTNULL AND end_time >= ?)', Time.now, Time.now)
    render :index
  end

  private


  def user_event_params
    params.require(:user_event).permit(:notes, :total_expense, :check_in, :check_out, :images, :follow_up, :recommended, :attendance, :sample)
  end

  def add_images(images, event)
    success = true
    error={}
    images_count=event.images.count
    unless images.nil?
      if event.images.count<5 and event.images.count+images.count<=5
        event.images += images
        event.save!
      else
        success = false
        if (5-images_count==0) or (5-images_count<0)
          error={:code => 709, :message => "There are already #{images_count} file uploaded.Cant upload files "}
        else
          error={:code => 709, :message => "There are already #{images_count} file uploaded.Upload upto #{5-images_count} files "}
        end
      end
    end
    return success, error
  end

end