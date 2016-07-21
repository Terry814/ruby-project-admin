$ ->
  $(document).pjax 'a.menu-link', '[data-pjax-container]', timeout: 5000

  $(document).on 'ready pjax:success', ->
    $(document).trigger 'appease:page_load'
    return

  $(document).on 'pjax:success', ->
    PixelAdmin.MainMenu::detectActiveItem.call window.PixelAdmin
    return

  $(document).on 'pjax:success', ->
    ga 'set', 'location', window.location.href
    ga 'send', 'pageview'
    return
    
  return