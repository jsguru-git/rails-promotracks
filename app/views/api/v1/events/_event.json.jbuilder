json.extract! event, :id, :name, :start_time, :end_time, :promo_category, :sample, :attendance, :total_expense, :follow_up, :notes, :check_in, :check_out, :event_type
json.images do
  json.array! event.images.map { |image| image.url }
end
json.address do
  json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
end