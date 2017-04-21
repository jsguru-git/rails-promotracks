json.success :true
json.events @events do |event|
  json.partial! 'api/v1/events/event', event: event
  if event.promo_rep?
    user_event=event.user_events.where(user_id: current_user.id, category: 0).first
  elsif event.promo_group?
    user_event=event.user_events.where(user_id: current_user.id, category: 1).first
  end
  json.user_event do
    json.extract! user_event, :total_expense, :follow_up, :notes, :check_in, :check_out, :recommended
    json.images do
      json.array! user_event.images.map { |image| image.url }
    end
  end
end
