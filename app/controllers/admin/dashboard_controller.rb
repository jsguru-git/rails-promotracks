class Admin::DashboardController < Admin::AdminApplicationController


  def index
    @events=@current_client.events.order("created_at asc").limit(2)
  end
end