json.extract! event, :id, :name, :start_time, :end_time, :promo_category
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
    json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
  end
end
