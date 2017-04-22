class Admin::GroupsController < Admin::AdminApplicationController


  def index
    @groups=@current_client.groups
  end

  def new
    @group=Group.new
    @promo_reps=@current_client.users.where(role: 'promo_rep')
  end

  def create
    @group=@current_client.groups.new(group_params)
    @group.user_ids= params[:group][:user_ids].delete_if { |x| x.empty? }
    @group.save
    redirect_to admin_groups_path
  end

  def edit
    @group=Group.find(params[:id])
    @promo_reps=@current_client.users.where(role: 'promo_rep')
  end

  def update
    @group=Group.find(params[:id])
    if @group.update_attributes(group_params)
      @group.update(user_ids: params[:group][:user_ids]) if params[:group][:user_ids]
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