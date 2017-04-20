json.success :true
json.events @events do |event|
  json.partial! 'api/v1/events/event', event: event
end
