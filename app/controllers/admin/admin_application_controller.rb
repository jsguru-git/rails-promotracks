module Admin
  class AdminApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    before_action :authenticate_admin
    layout 'admin/application'

    before_action :set_client

    def set_client
      @current_client = current_user.client
    end

    def authenticate_admin
      if current_user.client_admin? and !current_user.client_id.nil?
        true
      end
    end
  end
end

