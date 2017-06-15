class Superadmin::EventsController < Superadmin::SuperadminApplicationController


  def index
    @events = Event.active.order('updated_at desc')
    unless @events.kind_of?(Array)
      @events = @events.page(params[:page]).per(20)
    else
      @events = Kaminari.paginate_array(@events.uniq).page(params[:page]).per(20)
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.update_attribute(:deleted, true)
    flash[:notice] = 'Event deleted Successfully'
    redirect_to superadmin_events_path
  end

end