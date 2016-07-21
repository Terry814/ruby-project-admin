$.appease.controller 'one_time_pushes', ->
  $.appease.setupAndBindToAjax 'form#one-time-push-form', $.fn.validate
  return