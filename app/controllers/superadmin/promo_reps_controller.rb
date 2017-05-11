require 'platform/email_helper'
class Superadmin::PromoRepsController < Superadmin::SuperadminApplicationController
  include EmailHelper

  def index
    @promo_reps=User.where(role: 'promo_rep').order('first_name').collect { |u| u }
    unless @promo_reps.kind_of?(Array)
      @promo_reps = @promo_reps.page(params[:page]).per(10)
    else
      @promo_reps = Kaminari.paginate_array(@promo_reps.uniq).page(params[:page]).per(10)
    end
  end

  def new
    @promo_rep=User.new
  end

  def create
    pro_rep=User.new(user_params)
    pro_rep.password = generate_token
    pro_rep.token = generate_token
    if pro_rep.save
      UserJob.perform_later('add_rep', pro_rep)
      redirect_to superadmin_promo_reps_path
    else
      flash[:error]=pro_rep.errors.full_messages.join(', ')
      redirect_to :back
    end
  end


  def edit
    @promo_rep=User.find(params[:id])
  end

  def update
    @promo_rep=User.find(params[:id])
    if @promo_rep.update_attributes(user_params)
      redirect_to superadmin_promo_reps_path
    else
      flash[:error]=@promo_rep.errors.full_messages.join(', ')
      redirect_to :back
    end
  end


  def resend
    @promo_rep=User.find(params[:promo_rep_id])
    @promo_rep.update_attribute(:token, generate_token)
    UserJob.perform_later('resend_token', @promo_rep)
    flash[:notice] = "Password sent!"
    redirect_to superadmin_promo_reps_path
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :area)
  end
end