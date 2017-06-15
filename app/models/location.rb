class Location < ActiveRecord::Base
  belongs_to :event

  geocoded_by :full_address
  after_validation :geocode, if: Proc.new {|obj| (!obj.latitude.present? or !obj.longitude.present?)}


  def full_address
    if formatted_address.blank?
      [address_1, city, state, zip].compact.reject(&:empty?).join(', ')
    else
      formatted_address
    end

  end

  after_validation :reverse_geocode

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.time_zone = Timezone.lookup(geo.latitude, geo.longitude)
    end
  end
end
