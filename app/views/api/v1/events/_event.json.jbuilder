json.extract! event, :id, :name, :promo_category

json.start_time event.start_time
json.start_time_utc formatted_api_datetime(event.start_time)

json.end_time event.end_time
json.end_time_utc formatted_api_datetime(event.end_time)

json.event_type do
  json.extract! event.event_type, :id, :name
end
json.brand do
  if event.brand.nil?
    json.nil!
  else
    json.extract! event.brand, :id, :name, :description
  end
end
json.address do
  if event.address.nil?
    json.nil!
  else
    json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude ,:time_zone
  end
end
