class Admin::DashboardController < Admin::AdminApplicationController


  def index
    @events=@current_client.events.order("created_at desc").limit(2)
    @total=0
    @total_attendance=0
    @total_sample=0
    @events.each do |event|
      if event.user_events.collect { |c| c[:total_expense] }.any?
        @total=event.user_events.collect { |c| c[:total_expense] }.compact.reduce(0, :+)
        @total+=@total
      end
      if event.user_events.collect { |c| c[:attendance] }.any?
        @total_attendance=event.user_events.collect { |c| c[:attendance] }.compact.reduce(0, :+)
        @total_attendance+=@total_attendance
      end
      if event.user_events.collect { |c| c[:sample] }.any?
        @total_sample=event.user_events.collect { |c| c[:sample] }.compact.reduce(0, :+)
        @total_sample+=@total_sample
      end

    end
  end
end