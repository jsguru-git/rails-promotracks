module ApplicationHelper

  def bootstrap_class_for flash_type
    {success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info'}[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "text-center error_show_msg alert #{bootstrap_class_for(msg_type.to_sym)} fade in") do
               concat content_tag(:button, 'x', class: 'close', data: {dismiss: 'alert'})
               concat message
             end)
    end
    nil
  end

  def active_class(path)
    if ((['new', 'edit'].include? params[:action]) && (request.path.include? path)) || (request.path == path)
      'left-menu-list-active'
    else
      ''
    end
  end
end
