json.extract! event, :id, :name, :start_time, :end_time, :promo_category
json.event_type do
  json.extract! event.event_type, :id, :name
end
json.brand do
  json.extract! event.brand, :id, :name, :description
end
json.address do
  json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
end
