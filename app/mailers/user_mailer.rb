class UserMailer < ApplicationMailer

  def send_email(to_email, data)
    @data = data
    mail(:to => to_email, :subject => @data[:subject])
  end

end