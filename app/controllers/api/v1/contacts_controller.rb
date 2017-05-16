class Api::V1::ContactsController < Api::V1::ApiApplicationController

  skip_before_action :authenticate_user_from_token!, :only => [:create]

  def create
    unless params[:contact][:details].nil?
      @contact=Contact.new(:details => params[:contact][:details])
      @contact.save
    end
    UserJob.perform_later('contact', @contact)
  end

  private
  def contact_params
    params.require(:contact).permit(:details => {})
  end


end