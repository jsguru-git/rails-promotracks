class Superadmin::UsersController < Superadmin::SuperadminApplicationController

  def index
    @client=Client.find(params[:client_id])
    @users=@client.users
  end

  def new
    @client=Client.find(params[:client_id])
    @user=@client.users.new
  end

  def create
    @client=Client.find(params[:client_id])
    admin=@client.users.new(user_params)
    if admin.valid?
      @client.save
      redirect_to superadmin_client_users_path
    else
      flash[:error]=admin.errors.full_messages.join(', ')
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end


end