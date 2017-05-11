class EventsController < ApplicationController


  def show
    @event=Event.find(params[:id])
    if params[:token]
      user_event=UserEvent.find_by(token: params[:token])
      if @event.end_time < Time.now.utc
        @msg= "Event expired"
      else
        if user_event.promo_group?
          if params[:status]=="accept"
            if user_event.accepted?
              @msg= "Event accepted already!"
            else
              if @event.max_users > @event.user_events.where(:status => UserEvent::statuses[:accepted], :category => UserEvent::categories[:promo_group]).count
                user_event.status = :accepted
                user_event.save
                @msg= "Event accepted successfully!"
              else
                @msg= "Sorry!!Event reached max no of users!"
              end
            end

          elsif params[:status]=="decline"
            user_event.status = :declined
            user_event.save
            @msg= "Event declined sucessfully"
          end
        end
      end
    end
  end

end

