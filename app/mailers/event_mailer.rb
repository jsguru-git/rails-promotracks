class EventMailer < ApplicationMailer

  def accept_event(to_email, data)
    @data = data
    mail(:to => to_email, :subject => @data[:subject])
  end

end