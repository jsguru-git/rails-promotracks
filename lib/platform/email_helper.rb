module EmailHelper
  include ActionView::Helpers::NumberHelper


  def get_email_recipients(event, type)
    case type
      when 'accept'
        event.group.users.map(&:email).reject(&:blank?).uniq
      else
        []
    end
  end

  def promo_ref_info(user)
    data={}
    data[:id]=user.id
    data[:name]=user.full_name
    data[:email]=user.email
    data[:passcode]=user.token
    data
  end

  def get_event(event)
    data={}
    data[:id]=event.id
    data[:name]=event.name
    data[:start_time]=event.start_time
    data[:end_time]=event.end_time
    data[:brand_name]=event.brand.name
    data[:location]=event.address&.city
    data[:type]=event.type
  end


end