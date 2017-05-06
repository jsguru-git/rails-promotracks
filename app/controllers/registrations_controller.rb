class RegistrationsController < Devise::RegistrationsController
  acts_as_token_authentication_handler_for User
  skip_before_action :authenticate_scope!
  skip_before_action :authenticate_user_from_token!, :only => [:create]
  skip_before_action :verify_authenticity_token, if: :json_request?
  respond_to :json

  def new
    @client=Client.new
    super
  end
  def create
    build_resource(sign_up_params)
    resource.token = SecureRandom.hex[0, 6]
    if resource.save
      sign_up(resource_name, resource)
      resource.update_attributes(update_params)
      client=Client.new(client_params)
      client.admin = resource
      client.users << resource
      client.save
      respond_to do |format|
        format.html { redirect_to after_sign_up_path_for(resource), notice: "Signed Up Successfully" }
        format.json {
          render 'api/v1/sign_in', locals: {user: resource}
        }
      end
    else
      clean_up_passwords resource
      flash[:error] = resource.errors.full_messages.join(', ')
      respond_to do |format|
        format.html {
          redirect_to :back
          flash[:error]= resource.errors.full_messages.join(', ').to_s
        }
        format.json { render 'global/error', locals: {code: 701, message: resource.errors.full_messages.join(', ').to_s} }
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.client_admin?
      admin_dashboard_index_path
    else
      homes_path
    end
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end


  def update_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, client_attributes: [:name, :phone, :admin_id])
  end

  def client_params
    params[:user].require(:client).permit(:name, :phone)
  end

  def json_request?
    request.format.symbol == :json
  end
end