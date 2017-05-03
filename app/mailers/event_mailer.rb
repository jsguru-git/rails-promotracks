class EventMailer < ApplicationMailer

  def accept_event(to_email, data, token=nil)
    @data = data
    @data[:url]= event_url(:id => data[:event][:id], :token => token)
    mail(:to => to_email, :subject => @data[:subject])
  end

end