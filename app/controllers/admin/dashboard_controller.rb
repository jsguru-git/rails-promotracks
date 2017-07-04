class Admin::DashboardController < Admin::AdminApplicationController


  def index
    @events=@current_client&.events.active.includes(:user_events, :event_type).order_events(params[:sort_by])
    @total, @total_attendance, @total_sample, @total_product_cost, @total_payment=0.0
    sample=[]; total=[]; product_cost=[]; attendance=[]; final_pay=[]

    @events.each do |event|

      active_events=event.user_events.where(:status => UserEvent::statuses[:accepted])
      unless active_events.empty?
        total_expense=active_events.collect { |c| c[:total_expense] }.compact.reduce(0, :+)
        total << total_expense

        total_attendance=active_events.collect { |c| c[:attendance] }.compact.reduce(0, :+)
        attendance << total_attendance

        total_sample=active_events.collect { |c| c[:sample] }.compact.reduce(0, :+)
        sample << total_sample

        total_product_cost=active_events.collect { |c| (c[:sample]||0)* (event.brand&.unit_cost||0) }
        product_cost<<total_product_cost

        active_events.where.not(:check_in => nil, :check_out => nil).each do |active|
          hour=time_diff(active.check_out, active.check_in)
          pay=hour*(get_amount(event))
          final_pay << pay
        end
      end

    end
    @total_attendance=attendance.collect { |c| c }.compact.reduce(0, :+)
    @total_sample=sample.collect { |c| c }.compact.reduce(0, :+)
    @total=total.collect { |c| c }.compact.reduce(0, :+)
    @total_product_cost=product_cost.collect { |c| c }.compact.flatten.reduce(0, :+)
    @total_payment=final_pay.collect { |c| c }.compact.reduce(0, :+)
    respond_to do |format|
      format.html {}
      format.js {
        html = render_to_string :partial => 'admin/dashboard/events', layout: false, :locals => {:events => @events}
        render :json => {:success => true, :html => html} }

    end
  end


  def images
    @user_event=UserEvent.find(params[:user_event])
  end
end