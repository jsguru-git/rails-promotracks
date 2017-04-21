json.extract! event, :id, :name, :start_time, :end_time, :promo_category, :sample, :attendance, :event_type
json.address do
  json.extract! event.address, :city, :state, :zip, :country, :formatted_address, :latitude, :longitude
end
json.user_event do
  json.extract! @user_event, :total_expense, :follow_up, :notes, :check_in, :check_out, :recommended
  json.images do
    json.array! @user_event.images.map { |image| image.url }
  end
end