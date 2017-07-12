require 'platform/email_helper'
class Admin::PromoRepsController < Admin::AdminApplicationController
  include EmailHelper

  def index
    @promo_reps=@current_client.users.where(role: 'promo_rep').order('first_name').collect { |u| u }
    unless @promo_reps.kind_of?(Array)
      @promo_reps = @promo_reps.page(params[:page]).per(10)
    else
      @promo_reps = Kaminari.paginate_array(@promo_reps.uniq).page(params[:page]).per(10)
    end
  end

  def new
    @promo_rep=@current_client.users.new
  end

  def create
    pro_rep=User.find_by_email(user_params[:email])
    if pro_rep.nil?
      pro_rep=User.new(user_params)
      pro_rep.password = generate_token
      pro_rep.token = generate_token
      if pro_rep.valid?
        @current_client.users << pro_rep
        @current_client.save
        UserJob.perform_later('add_rep', pro_rep)
        redirect_to admin_promo_reps_path
      else
        flash[:error]=pro_rep.errors.full_messages.join(', ')
        redirect_to :back
      end
    elsif @current_client.users.include? pro_rep
      flash[:error]= "Direct Sourced Already Exsits"
      redirect_to :back
    else
      @current_client.users << pro_rep
      @current_client.save
      flash[:notice] = "Direct Sourced information is found already and added to your Direct Sourced"
      redirect_to admin_promo_reps_path
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


  def resend
    @promo_rep=@current_client.users.find(params[:promo_rep_id])
    @promo_rep.update_attribute(:token, generate_token)
    UserJob.perform_later('resend_token', @promo_rep)
    flash[:notice] = "Password sent!"
    redirect_to admin_promo_reps_path
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :area ,:phone)
  end
end