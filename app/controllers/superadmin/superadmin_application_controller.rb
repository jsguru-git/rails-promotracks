module Superadmin
  class SuperadminApplicationController < ApplicationController
    protect_from_forgery with: :exception

    before_action :authenticate_user!

    layout 'superadmin/application'

    def authenticate_superadmin
      if current_user.super_admin? and ENV['superadmins'].split(',').include? current_user.email
        true
      end
    end

  end
end
