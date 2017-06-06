namespace :user_events do
  task :set_recap => :environment do
    UserEvent.accepted.each do |uv|
      if uv.follow_up.blank?
        uv.recap = false
      else
        uv.recap = true
      end
      uv.save
    end
  end
end