require 'platform/email_helper'
class Admin::PromoRepsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    @promo_reps=@current_client.users&.where(role: 'promo_rep').collect { |u| u }
    unless @promo_reps.kind_of?(Array)
      @promo_reps = @promo_reps.page(params[:page]).per(10)
    else
      @promo_reps = Kaminari.paginate_array(@promo_reps.uniq).page(params[:page]).per(4)
    end
  end

  def new
    @promo_rep=@current_client.users.new
  end

  def create
    pro_rep=@current_client.users.new(user_params)
    pro_rep.password = (10000..99999).to_a.sample
    pro_rep.token = (10000..99999).to_a.sample
    if pro_rep.valid?
      pro_rep.save
      email_data={}
      email_data[:body] = "find below the passcode for the promo rep"
      email_data[:subject]="New Promo Rep :#{pro_rep.id}"
      email_data[:user]=promo_ref_info(pro_rep)
      UserMailer.send_email(pro_rep.email, email_data).deliver
      redirect_to admin_promo_reps_path
    else
      flash[:error]=pro_rep.errors.full_messages.join(', ')
      redirect_to :back
    end
  end


  def edit
    @promo_rep=@current_client.users.find(params[:id])
  end

  def update
    @promo_rep=@current_client.users.find(params[:id])
    if @promo_rep.update_attributes(user_params)
      redirect_to admin_promo_reps_path
    else
      flash[:error]=@promo_rep.errors.full_messages.join(', ')
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end
end