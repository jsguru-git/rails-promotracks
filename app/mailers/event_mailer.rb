class EventMailer < ApplicationMailer

  def accept_event(to_email, data,token)
    @data = data
    @data[:token]= token
    mail(:to => to_email, :subject => @data[:subject])
  end

end