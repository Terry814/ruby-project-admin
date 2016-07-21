module MenuHelper
  def menu_group text, icon, &submenus
    content_tag :li, class: 'mm-dropdown' do
      menu_link_to(text, '#', icon) +
      content_tag(:ul, capture(&submenus))
    end
  end

  def menu_item text, link, icon, li_options = nil, &append
    content_tag :li, li_options do
      menu_link_to text, link, icon, {class: 'menu-link'}, &append
    end
  end

  def submenu text, link, icon, li_options = nil, &append
    content_tag :li, li_options do
      menu_link_to text, link, icon, {class: 'menu-link', tabindex: -1}, &append
    end
  end

  def no_pjax_menu_item text, link, icon, li_options = nil, &append
    content_tag :li, li_options do
      menu_link_to text, link, icon, &append
    end
  end

  private

  def menu_link_to text, link, icon, options = nil, &append
    append = block_given? ? capture(&append) : ''
    link_to link, options do
      content_tag(:i, '', class: "menu-icon fa #{icon}") +
      content_tag(:span, text, class: "mm-text") +
      append
    end
  end
end