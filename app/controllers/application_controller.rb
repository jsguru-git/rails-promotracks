class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    if resource.super_admin?
      superadmin_events_path
    elsif resource.client_admin?
      admin_promo_reps_path
    else
      homes_path
    end
  end
end
