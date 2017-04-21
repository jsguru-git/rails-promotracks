class Superadmin::EventTypesController < Superadmin::SuperadminApplicationController


  def index
    @event_types=EventType.all
  end


  def new
    @event_type=EventType.new
  end

  def create
    @event_type=EventType.new(event_type_params)
    if @event_type.valid?
      @event_type.save
      redirect_to superadmin_event_types_path
    else
      flash[:error]=@event_type.errors.full_messages.join(', ')
      render :new
    end
  end

  private
  def event_type_params
    params.require(:event_type).permit(:name)
  end

end