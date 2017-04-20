json.extract! event, :name, :start_time, :end_time, :promo_category
json.address do
  json.extract! event.address, :city
end