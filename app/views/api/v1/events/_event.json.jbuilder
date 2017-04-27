json.extract! event, :id, :name, :start_time, :end_time, :promo_category, :event_type
json.brand do
  json.extract! event.brand, :id, :name, :description
end
json.address do
  json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
end
