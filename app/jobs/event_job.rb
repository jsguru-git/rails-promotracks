require 'platform/email_helper'
class EventJob < ApplicationJob
  queue_as :default
  include EmailHelper

  def perform(type, event, user_ids, params = {})
    case type
      when 'event'
        email_data={}
        email_data[:body] = "Please find below the event details"
        email_data[:subject]="#{event.name} :#{event.id}"
        user_ids.each do |id|
          user=User.find(id)
          user_event=event.user_events.where(:user_id => user.id).first
          email_data[:event]=get_event(event, user)
          EventMailer.accept_event(user.email, email_data, {token: user_event.token, category: user_event.category}).deliver
        end
    end
  end

end



