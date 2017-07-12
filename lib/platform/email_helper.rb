module EmailHelper
  include ActionView::Helpers::NumberHelper


  def promo_ref_info(user)
    data={}
    data[:id]=user.id
    data[:name]=user.full_name
    data[:email]=user.email
    data[:passcode]=user.token
    data
  end

  def get_event(event, user)
    data={}
    data[:user]=user&.first_name
    data[:id]=event.id
    data[:category]=event.promo_category
    data[:name]=event&.name
    data[:start_time]=((event.start_time).in_time_zone(event.address.time_zone))&.strftime('%m/%d/%Y %I:%M %p')
    data[:end_time]=((event.end_time).in_time_zone(event.address.time_zone))&.strftime('%m/%d/%Y %I:%M %p')
    data[:brand_name]=event.brand&.name
    data[:location]=event.address&.city
    data[:notes] = event.notes
    data[:event_type]=event.event_type&.name
    data[:client_name]= event.client.name
    data[:client_email]= event.client.admin.email
    data[:client_phone]= event.client.phone
    data
  end

  def get_contact(contact)
    data={}
    data[:first_name]=contact.details["first_name"]
    data[:last_name]= contact.details["last_name"]
    data[:email]= contact.details["email"]
    data[:phone] = contact.details["phone"]
    data[:city]= contact.details["city"]
    data[:comments] = contact.details["comments"]
    data
  end


end