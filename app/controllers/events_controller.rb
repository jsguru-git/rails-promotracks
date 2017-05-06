class EventsController < ApplicationController

  # skip_before_filter :authenticate_user_from_token!, :only => [:show]

  def show
    @event=Event.find(params[:id])
    if params[:token]
      user_event=UserEvent.find_by(token: params[:token])
      if params[:status]=="accept"
        if @event.max_users > @event.user_events.where(:status => UserEvent::statuses[:accepted]).count
          user_event.status = :accepted
          user_event.save
          @msg= "Event accepted successfully!"
        else
          @msg= "Event reached max no of users!"
        end
      elsif params[:status]=="decline"
        user_event.status = :declined
        user_event.save
        @msg= "Event declined sucessfully"
      end
    end
  end

end

