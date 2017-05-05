class Superadmin::GroupsController < Superadmin::SuperadminApplicationController


  def index
    @groups=Group.all.page(params[:page]).per(10)
  end

  def new
    @group=Group.new
    @promo_reps=User.where(role: 'promo_rep', :group_id => nil)
  end

  def create
    @group=Group.new(group_params)
    @group.user_ids= params[:group][:user_ids].delete_if { |x| x.empty? }
    @group.save
    redirect_to superadmin_groups_path
  end

  def edit
    @group=Group.find(params[:id])
    @promo_reps=User.where(role: 'promo_rep')
  end

  def update
    @group=Group.find(params[:id])
    if @group.update_attributes(group_params)
      @group.update(user_ids: params[:group][:user_ids]) if params[:group][:user_ids]
      redirect_to superadmin_groups_path
    else
      flash[:error]=@group.errors.full_messages.join(', ')
      redirect_to :back
    end
  end


  private
  def group_params
    params.require(:group,).permit(:name)
  end
end