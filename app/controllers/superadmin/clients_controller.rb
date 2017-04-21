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
    redirect_to superadmin_clients_path
  end


  private

  def client_params
    params.require(:client).permit(:name, :phone, :brand_ids, admin_attributes: [:first_name, :last_name, :password, :password_confirmation, :email, :role])
  end


end