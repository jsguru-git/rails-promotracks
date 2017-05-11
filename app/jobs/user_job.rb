require 'platform/email_helper'
class UserJob < ApplicationJob
  queue_as :default
  include EmailHelper

  def perform(type, promo_rep, params = {})
    case type
      when 'add_rep', 'resend_token'
        email_data={}
        email_data[:body] = "find below the new passcode for the promo rep"
        email_data[:subject]="New  passcode for Promo Rep :#{promo_rep.id}"
        email_data[:user]=promo_ref_info(promo_rep)
        UserMailer.send_code(promo_rep.email, email_data).deliver
    end
  end
end



