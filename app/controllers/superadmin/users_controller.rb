class Superadmin::UsersController < Superadmin::SuperadminApplicationController

  def index
    @client=Client.find(params[:client_id])
    @users=@client.users.where(:role => :client_admin)
  end

  def new
    @client=Client.find(params[:client_id])
    @user=@client.users.new
  end

  def create
    @client=Client.find(params[:client_id])
    admin=User.new(user_params)
    admin.invite!
    if admin.valid?
      @client.users << admin
      @client.save
      flash[:notice]= "Admin Invited Sucessfully"
      redirect_to superadmin_client_users_path
    else
      flash[:error]=admin.errors.full_messages.join(', ')
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end


end