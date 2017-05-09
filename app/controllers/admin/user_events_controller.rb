class Admin::UserEventsController < Admin::AdminApplicationController


  def edit
    @event = Event.find(params[:event_id])
    @user_event = @event.user_events.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])
    @user_event = @event.user_events.find(params[:id])
    unless user_event_params[:images].nil?
      success, error, images= add_images(user_event_params[:images], @user_event)
      if success
        user_event_params[:images]=images
      else
        flash[:error]= error[:message].to_s
        redirect_to :back
        return
      end
    end
    if @user_event.update_attributes(user_event_params)
      @user_event.update_attribute(:images, images)
      @user_event.update_attribute(:check_in, Time.zone.strptime(user_event_params[:check_in], '%m/%d/%Y %I:%M %p')) unless user_event_params[:check_in].nil?
      @user_event.update_attribute(:check_out, Time.zone.strptime(user_event_params[:check_out], '%m/%d/%Y %I:%M %p')) unless user_event_params[:check_out].nil?
      flash[:notice]="Updated Successfully"
      redirect_to admin_event_path(@event)
    else
      flash[:error]=@user_event.errors.full_messages.join(', ')
      redirect_to :back
    end
  end


  def delete_image
    @event = Event.find(params[:event_id])
    @user_event = @event.user_events.find(params[:user_event_id])
    remain_images = @user_event.images # copy the array
    deleted_image = remain_images.delete_at(params[:index].to_i) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    if remain_images.empty?
      @user_event.remove_images!
    else
      @user_event.images = remain_images
      @user_event.images_will_change!
    end
    puts remain_images.to_json
    puts @user_event.changes
    @user_event.save!
    respond_to do |format|
      format.html {
      }
      format.js {
        render :json => {:success => :true}
      }
    end
  end


  private
  def user_event_params
    params.require(:user_event).permit(:notes, :total_expense, :check_in, :check_out, :follow_up, :recommended, :attendance, :sample, :images => [])
  end

end