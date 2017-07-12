class Admin::GroupsController < Admin::AdminApplicationController


  def index
    @groups=@current_client.groups.page(params[:page]).per(10)
  end

  def new
    @group=@current_client.groups.new
    @promo_reps=@current_client.users.promo_rep.uniq
  end

  def create
    @group=Group.new(group_params)
    @group.user_ids= params[:group][:user_ids].reject(&:blank?)
    @group.save
    @current_client.groups << @group
    @current_client.save
    redirect_to admin_groups_path
  end

  def edit
    @group=@current_client.groups.find(params[:id])
    @promo_reps=@current_client.users.promo_rep.uniq
  end

  def update
    @group=@current_client.groups.find(params[:id])
    @group.assign_attributes(group_params)
    if @group.valid?
      @group.user_ids = params[:group][:user_ids].reject(&:blank?)
      @group.save
      redirect_to admin_groups_path
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