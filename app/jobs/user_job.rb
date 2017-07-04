require 'platform/email_helper'
class UserJob < ApplicationJob
  queue_as :default
  include EmailHelper

  def perform(type, promo_rep, params = {})
    case type
      when 'add_rep', 'resend_token'
        email_data={}
        email_data[:body] = "find below the new passcode for the Direct Sourced"
        email_data[:subject]="New  passcode for Direct Sourced :#{promo_rep.id}"
        email_data[:user]=promo_ref_info(promo_rep)
        UserMailer.send_code(promo_rep.email, email_data).deliver
      when 'contact'
        email_data={}
        email_data[:body] = "Find below the New Direct Sourced details"
        email_data[:subject]="New Direct Sourced Registered"
        email_data[:contact]=get_contact(promo_rep)
        UserMailer.send_contact(promo_rep.details["email"], email_data).deliver
    end
  end
end



