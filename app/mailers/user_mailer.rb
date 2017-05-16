class UserMailer < ApplicationMailer

  def send_email(to_email, data)
    @data = data
    mail(:to => to_email, :subject => @data[:subject])
  end

  def send_code(to_email, data)
    @data = data
    mail(:to => to_email, :subject => @data[:subject])
  end

  def send_contact(to_email, data)
    @data = data
    if Rails.env.production?
      email = 'admin@promotracks.com'
    else
      email = 'admin@promotracks.com'
    end
    mail(:to => email, :subject => @data[:subject])
  end

end