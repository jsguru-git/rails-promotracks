json.success :true
json.event do
  json.partial! 'api/v1/events/event', event: @event
end