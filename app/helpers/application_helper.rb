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


  def time_diff(end_time, start_time)
    hours=((end_time.to_i - start_time.to_i)/(60 * 60.00)).abs.round
    if hours > 1
      hours
    else
      1
    end
  end


  def formatted_api_datetime(datetime)
    if datetime.blank?
      ''
    else
      datetime.strftime('%Y-%m-%dT%H:%M:%SZ')
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

  def get_amount(event)
    if !event.client.payment.blank?
      event.client.payment
    elsif !event.pay.blank?
      event.pay
    end
  end

end
