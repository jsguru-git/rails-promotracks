class Superadmin::UsersController < Superadmin::SuperadminApplicationController

  def index
    @client=Client.find(params[:client_id])
    @users=@client.users.active_users.client_admin
  end

  def new
    @client=Client.find(params[:client_id])
    @user=@client.users.new
  end

  def create
    @client=Client.find(params[:client_id])
    user = User.find_by_email(params[:user][:email])
    if user.nil?
      user=User.new(user_params)
      user.invite!
      @client.users << user
      @client.save
      flash[:notice]= "Admin Invited Sucessfully"
      redirect_to superadmin_client_users_path
    else
      flash[:error]= "User Already Exists"
      redirect_to :back
    end
  end

  def resend_invitation
    @user = User.find(params[:user_id])
    @user.invite!
    flash[:notice] = 'Invitation sent!'
    redirect_to superadmin_client_users_path
  end

  def destroy
    @client=Client.find(params[:client_id])
    @user = User.find(params[:id])
    @user.update_attribute(:deleted , true)
    flash[:notice] = 'Admin deleted successfully!'
    redirect_to superadmin_client_users_path
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end


end