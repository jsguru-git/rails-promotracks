class Api::V1::EventsController < Api::V1::ApiApplicationController


  def index
    @events=current_user.events
  end

end