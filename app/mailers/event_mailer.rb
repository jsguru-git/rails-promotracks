class EventMailer < ApplicationMailer

  def accept_event(to_email, data, token=nil)
    @data = data
    Rails.logger.info "#{root_url}"
    Rails.logger.info "#{event_url(:id => data[:event][:id], :token => token)}"
    @data[:url]= "#{root_url}/events/#{data[:event][:id]}?token=#{token}"
    mail(:to => to_email, :subject => @data[:subject])
  end

end