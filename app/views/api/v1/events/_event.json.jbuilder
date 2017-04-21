json.extract! event, :id, :name, :start_time, :end_time, :promo_category, :sample, :attendance, :event_type
json.address do
  json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
end
