module PanelViewHelper
  # options: title, icon, class, id, body_class, footer, title_label, title_label_class
  def panel_view options = {}, &block
    icon = content_tag(:i, '', class: "panel-title-icon fa #{options[:icon]}") if options[:icon]
    title_label = content_tag(:span, options[:title_label], class: "label #{options[:title_label_class]}") if options[:title_label]

    heading = if options[:heading_text]
      content_tag(:div, class: "panel-heading-controls") do
        content_tag(:span, options[:heading_text], class: "panel-heading-text")
      end
    end
    footer = content_tag(:div, options[:footer], class: "panel-footer") if options[:footer]
    class_str = options[:class] ? " #{options[:class]}" : ''
    id_str = options[:id] ? " id=\"#{options[:id]}\"" : ''

    html = <<-HTML
    <div class="panel#{class_str}"#{id_str}>
      <div class="panel-heading">
        <span class="panel-title">#{icon}#{options[:title]}</span>
        #{title_label}
        #{heading}
      </div>
      <div class="panel-body #{options[:body_class]}">
        #{capture(&block)}
      </div>
      #{footer}
    </div>
    HTML

    html.html_safe
  end

  def menu_settings_panel
    panel_view(title: "Basic settings", icon: "fa-cogs") { yield }
  end
end