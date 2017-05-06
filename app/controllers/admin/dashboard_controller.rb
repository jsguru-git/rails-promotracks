class Admin::DashboardController < Admin::AdminApplicationController


  def index
    @events=@current_client&.events.includes(:user_events).where(:user_events => {:status => UserEvent::statuses[:accepted]}).order("created_at desc")
    @total=0.0
    @total_attendance=0
    @total_sample=0
    @total_product_cost=0.0
    sample=[]
    total=[]
    product_cost=[]
    attendance=[]
    final_pay=[]
    @events.each do |event|

      active_events=event.user_events.where(:status => UserEvent::statuses[:accepted])

      total_expense=active_events.collect { |c| c[:total_expense] }.compact.reduce(0, :+)
      total << total_expense

      total_attendance=active_events.collect { |c| c[:attendance] }.compact.reduce(0, :+)
      attendance << total_attendance

      total_sample=active_events.collect { |c| c[:sample] }.compact.reduce(0, :+)
      sample << total_sample

      total_product_cost=active_events.collect { |c| c[:sample]* event.brand.unit_cost }
      product_cost<<total_product_cost

      active_events.where.not(:check_in=>nil,:check_out=>nil).each do |active|
        hour=((active.check_out - active.check_in)/3600).round
        pay=hour*event.pay
        final_pay << pay
      end
    end
    @total_attendance=attendance.collect { |c| c }.compact.reduce(0, :+)
    @total_sample=sample.collect { |c| c }.compact.reduce(0, :+)
    @total=total.collect { |c| c }.compact.reduce(0, :+)
    @total_product_cost=product_cost.collect { |c| c }.compact.flatten.reduce(0, :+)
    @total_payment=final_pay.collect { |c| c }.compact.reduce(0, :+)
  end
end