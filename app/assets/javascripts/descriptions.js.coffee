$.appease.controller 'descriptions', ->
  $.appease.setupAndBindToAjax 'form#ios-form', $.fn.validate
  $.appease.setupAndBindToAjax 'form#android-form', $.fn.validate
  return