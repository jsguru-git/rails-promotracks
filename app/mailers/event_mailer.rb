class EventMailer < ApplicationMailer

  def accept_event(to_email, data, params)
    @data = data
    @data[:token]= params[:token]
    @data[:type]=params[:category]
    mail(:to => to_email,:cc=> 'admin@promotracks.com', :subject => @data[:subject])
  end

end