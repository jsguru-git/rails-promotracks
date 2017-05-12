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

    "#{hours.to_s.rjust(2, '0')}".to_i
  end

  # def time_diff(start_time, end_time)
  #   seconds=(( start_time -end_time) * 24 * 60 * 60).to_i
  #   Time.at(seconds).strftime("%H")
  # end

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
