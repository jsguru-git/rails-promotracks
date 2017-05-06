class InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_accept_path_for(resource)
    if resource.super_admin?
      superadmin_clients_path
    elsif resource.client_admin?
      admin_dashboard_index_path
    else
      homes_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :email])
  end

end