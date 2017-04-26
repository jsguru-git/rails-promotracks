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

end
