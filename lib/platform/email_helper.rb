module EmailHelper
  include ActionView::Helpers::NumberHelper


  def promo_ref_info(user)
    data={}
    data[:id]=user.id
    data[:name]=user.full_name
    data[:email]=user.email
    data[:passcode]=user.token
    data[:client]=user.client
    data
  end

  def get_event(event)
    data={}
    data[:id]=event.id
    data[:category]=event.promo_category
    data[:name]=event.name
    data[:start_time]=event.start_time
    data[:end_time]=event.end_time
    data[:brand_name]=event.brand.name
    data[:location]=event.address&.city
    data[:event_type]=event.event_type&.name
    data
  end


end