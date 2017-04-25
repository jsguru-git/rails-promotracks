module Admin
  class AdminApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    before_action :authenticate_admin
    layout 'admin/application'

    before_action :set_client

    def set_client
      @current_client = Client.where(:admin_id => current_user.id).first
    end

    def authenticate_admin
      if current_user.client_admin? and !current_user.client_id.nil?
        true
      end
    end

    def login_as_master
      if session[:slave_user_id].blank?
        flash[:error] = 'Sorry! Unable to process!'
        redirect_back fallback_location: superadmin_clients_path
      else
        if session[:slave_user_id] == current_user.id
          session[:slave_user_id] = nil
          redirect_to admin_events_path
        else
          flash[:error] = 'Sorry! Unable to process!'
          redirect_back fallback_location: superadmin_clients_path
        end
      end
    end
  end
end

