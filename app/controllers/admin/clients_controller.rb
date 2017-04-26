class Admin::ClientsController < Admin::AdminApplicationController

  def reps_and_groups
    match=[]
    @groups=@current_client.groups.where("name ILIKE? ", "%#{params[:term]}%").order('name ASC')
    @users=@current_client.users.where("first_name ILIKE :search OR last_name ILIKE :search", search: "%#{params[:term]}%")
    @users.each do |user|
      match << {id: user.id, label: user.full_name, value: user.full_name, type: user.role}
    end
    @groups.each do |group|
      match << {id: group.id, label: group.name, value: group.name, type: 'promo_group'}
    end
    respond_to do |format|
      format.html
      format.json {
        render json: match
      }
    end
  end


end