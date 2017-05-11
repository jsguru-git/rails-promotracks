require 'platform/email_helper'
class EventJob < ApplicationJob
  queue_as :default
  include EmailHelper


end



