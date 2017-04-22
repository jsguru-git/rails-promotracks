class Superadmin::ClientsController < Superadmin::SuperadminApplicationController


  def index
    @clients=Client.all
  end

  def new
    @client=Client.new
    @admin=@client.build_admin
  end

  def create
    @client=Client.new(client_params)
    @client.brand_ids = params[:client][:brand_ids].delete_if { |x| x.empty? }
    @client.save
    @client.admin.update(client_id: @client.id)
    redirect_to superadmin_clients_path
  end

  def edit
    @client=Client.find(params[:id])
    @admin=@client.admin
  end

  def update
    @client=Client.find(params[:id])
    client_call_params= client_params
    if client_params[:admin_attributes][:password].empty?
      client_call_params = client_update_params
    end
    if @client.update_attributes(client_call_params)
      redirect_to superadmin_clients_path
    else
      flash[:error]=@client.errors.full_messages.join(', ')
      redirect_to :back
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :phone, :brand_ids, admin_attributes: [:id, :first_name, :last_name, :password, :password_confirmation, :email, :role])
  end

  def client_update_params
    params.require(:client).permit(:name, :phone, :brand_ids, admin_attributes: [:id, :first_name, :last_name, :email, :role, :client_id])
  end


end