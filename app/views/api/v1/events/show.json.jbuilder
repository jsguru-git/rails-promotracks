json.success :true
json.event do
  json.partial! 'api/v1/events/event', event: @event
  json.user_event do
    json.extract! @user_event, :total_expense, :follow_up, :notes, :check_in, :check_out, :recommended, :recap,:sample, :attendance
    json.images do
      json.array! @user_event.images.map { |image| image.url }
    end
  end
end