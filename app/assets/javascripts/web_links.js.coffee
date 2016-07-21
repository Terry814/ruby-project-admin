$.appease.controller 'web_links', ->
  $.appease.setupAndBindToAjax 'form#new_web_link', $.fn.validate
  return