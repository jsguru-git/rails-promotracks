module ApplicationHelper

  def bootstrap_class_for flash_type
    {success: 'success', error: 'danger', alert: 'warning', notice: 'info'}[flash_type] || flash_type.to_s
  end

  def active_class(path)
    if ((['new', 'edit'].include? params[:action]) && (request.path.include? path)) || (request.path == path)
      'left-menu-list-active'
    else
      ''
    end
  end

  def generate_token
    (10000..99999).to_a.sample
  end


  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff
    puts "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
    if (minutes.to_s.rjust(2, '0').to_i > 35) and (minutes.to_s.rjust(2, '0').to_i < 59)
      hours= minutes.to_s.rjust(2, '0').to_i+1
    else
      hours=hours.to_s.rjust(2, '0').to_i
    end
    if hours < 1
      1
    else
      hours
    end
  end


  def add_images(images, event)
    success = true
    error={}
    images_count=event.images.count
    unless images.nil?
      if event.images.count<5 and event.images.count+images.count<=5
        event.images += images
      else
        success = false
        if (5-images_count==0) or (5-images_count<0)
          error={:code => 709, :message => "There are already #{images_count} file uploaded.Cant upload files "}
        else
          error={:code => 709, :message => "There are already #{images_count} file uploaded.Upload upto #{5-images_count} files "}
        end
      end
    end
    return success, error, event.images
  end

end
