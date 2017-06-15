namespace :locations do
  task :set_time_zone => :environment do
    Location.all.each do |location|
      unless location.longitude.blank? and location.latitude.blank?
        begin
          location.time_zone=Timezone.lookup(location.latitude, location.longitude)
          location.save
        rescue Exception => e
          puts "#{location.id}: #{e.message}"
        end
      end
    end
  end
end