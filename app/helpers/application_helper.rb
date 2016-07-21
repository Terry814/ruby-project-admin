module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type
    end
  end

  def page_title(separator = " – ")
    [content_for(:title), 'AppEase'].compact.join(separator)
  end

  def content_class id
    class_str = content_for(id)
    return '' if class_str.blank?
    class_str.prepend(' ')
  end

  def publishing_changes
    content_tag(:i, '', class: "fa fa-flag-checkered") + " changes require app publishing"
  end
end
