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
    mail(:to => 'admin@promotracks.com', :subject => @data[:subject])
  end

end