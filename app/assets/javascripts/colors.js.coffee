$.appease.controller 'colors', ->
  setupColorChangeListener = ->
    $('.color-field', 'form.edit_app_colors').on 'change.custom_listener', ->
      $('#scheme_custom', 'form.theme').prop 'checked', true
      return
    return

  withDisabledColorChangeListener = (js) ->
    $('.color-field', 'form.edit_app_colors').off 'change.custom_listener'
    js?()
    setupColorChangeListener()
    return

  $.appease.setupAndBindToAjax 'form.edit_app_colors', ->
    @find('.color-field').minicolors
      control: 'hue'
      letterCase: 'uppercase'
      position: $(@).data('position') || 'bottom left'
      theme: 'bootstrap'

    setupColorChangeListener()
    @validate()
    return

  themes =
    dark:
      app_colors_header_bg_color: '#1D1D1D'
      app_colors_header_text_color: '#FAFAFA'
      app_colors_separator_color: '#272727'
      app_colors_separator_accent_color: '#1B1B1B'
      app_colors_menu_cell_bg_color: '#202020'
      app_colors_menu_cell_text_color: '#EEEEEE'
      app_colors_menu_top_bg_color: '#1D1D1D'
      app_colors_menu_top_text_color: '#FAFAFA'
    light:
      app_colors_header_bg_color: '#F2F2F2'
      app_colors_header_text_color: '#3B3B3B'
      app_colors_separator_color: '#E4E4E4'
      app_colors_separator_accent_color: '#FAFAFA'
      app_colors_menu_cell_bg_color: '#F7F7F7'
      app_colors_menu_cell_text_color: '#868686'
      app_colors_menu_top_bg_color: '#F2F2F2'
      app_colors_menu_top_text_color: '#3B3B3B'

  $.each themes, (name, colors) ->
    match = true
    $.each colors, (id, color) ->
      # jQuery stops loop if false returned in $.each()
      match = $("##{id}").val() == color

    if match
      $("input[name=\"theme[scheme]\"][value=#{name}]", 'form.theme').prop 'checked', true
    return !match

  $('input[name="theme[scheme]"]', 'form.theme').change ->
    if colors = themes[$(@).val()]
      withDisabledColorChangeListener ->
        $.each colors, (id, color) ->
          $("##{id}").minicolors 'value', color
          return
        return
    return

  return
