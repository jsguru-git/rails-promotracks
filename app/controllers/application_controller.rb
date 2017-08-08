class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery
  # before_action :authenticate_user!

  def set_notification
    request.env['exception_notifier.exception_data'] = {'server' => Rails.env}
    # can be any key-value pairs
  end

  def after_sign_in_path_for(resource)
    if resource.super_admin?
      superadmin_clients_path
    elsif resource.client_admin?
      admin_dashboard_index_path
    else
      homes_path
    end
  end

  alias_method :orig_current_user, :current_user
  helper_method :current_user
  helper_method :orig_current_user

  def current_user
    if session[:slave_user_id]
      @current_slave_user ||= User.find(session[:slave_user_id].to_i)
    else
      orig_current_user
    end
  end

  helper_method :current_user_slave?

  def current_user_slave?
    !session[:slave_user_id].nil?
  end

end
