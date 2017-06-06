json.success :true
json.events @events do |event|
  json.partial! 'api/v1/events/event', event: event
  user_event=event.user_events.where(user_id: current_user.id, status: UserEvent::statuses[:accepted]).first
  json.user_event do
    if user_event.nil?
      json.nil!
    else
      json.extract! user_event, :sample, :attendance, :total_expense, :follow_up, :notes, :check_in, :check_out, :recommended ,:recap
      json.images do
        json.array! user_event.images.map { |image| image.url }
      end
    end

  end
end
