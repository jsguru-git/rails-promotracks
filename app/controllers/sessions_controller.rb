class SessionsController < Devise::SessionsController
  respond_to :json
  prepend_before_action :verify_user, only: [:destroy]

  def create
    self.resource = warden.authenticate(auth_options)
    respond_to do |format|
      format.html {
        if resource
          if resource.deleted
            sign_out_and_redirect(user_session_path,"Not Authorized to login!")
            return
          end
          sign_in(resource_name, resource)
        else
          sign_out_and_redirect(user_session_path, "Invalid Username or Password")
        end
        if user_signed_in?
          respond_with resource, :location => after_sign_in_path_for(resource), notice: "Signed In Successfully"
        end
      }
      format.json {
        user = User.find_by(:token => params[:user][:token])
        if !user.nil?
          sign_in(resource_name, user)
        else
          sign_out_and_redirect(user_session_path, "Invalid Password")
        end
        if user_signed_in?
          render 'api/v1/sign_in', locals: {user: user}
        end
      }
    end
  end

  def auth_options
    {scope: resource_name, recall: "#{controller_path}#new"}
  end

  def sign_out_and_redirect(path, message)
    respond_to do |format|
      format.html {
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        yield if block_given?
        redirect_to path
        # redirect_to user_session_path
        flash[:error] = message
      }
      format.json {
        render 'global/error', :locals => {:code => 701, :message => "Invalid Password"}
      }
    end

  end

  private

  # def sign_in_params
  #   params.require(:user).permit(:email, :password)
  # end

  ## This method intercepts SessionsController#destroy action
  ## If a signed in user tries to sign out, it allows the user to sign out
  ## If a signed out user tries to sign out again, it redirects them to sign in page
  def verify_user
    ## redirect to appropriate path
    redirect_to new_user_session_path, notice: 'You have already signed out. Please sign in again.' and return unless user_signed_in?
  end
end