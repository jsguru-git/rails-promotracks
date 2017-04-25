require 'platform/settings'
ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
                                       :access_key_id => ENV['aws_access_key_id'],
                                       :secret_access_key => ENV['aws_secret_access_key'],
                                       :server => PromoRails::Settings::SES.host