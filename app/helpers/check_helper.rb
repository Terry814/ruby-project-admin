module CheckHelper
  def check_or_close bool
    bool ? fa_check : fa_close
  end

  def fa_check
    content_tag(:i, '', class: 'panel-title-icon fa fa-check')
  end

  def fa_close
    content_tag(:i, '', class: 'panel-title-icon fa fa-close')
  end
end
