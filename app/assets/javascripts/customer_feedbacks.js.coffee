$.appease.controller 'customer_feedbacks', ->
  $.appease.setupAndBindToAjax 'form#customer-feedback-form', $.fn.validate
  $.appease.setupAndBindToAjax 'form#customer-feedback-info-form', $.fn.validate
  return