class Superadmin::GroupsController < Superadmin::SuperadminApplicationController


  def index
    @groups=Group.all.page(params[:page]).per(10)
  end

  def new
    @group=Group.new
    @promo_reps=User.promo_rep
  end

  def create
    @group=Group.new(group_params)
    @group.user_ids= params[:group][:user_ids].reject(&:blank?)
    @group.save
    redirect_to superadmin_groups_path
  end

  def edit
    @group=Group.find(params[:id])
    @promo_reps=User.promo_rep
  end

  def update
    @group=Group.find(params[:id])
    @group.assign_attributes(group_params)
    if @group.valid?
      @group.user_ids = params[:group][:user_ids].reject(&:blank?)
      @group.save
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