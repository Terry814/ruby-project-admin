$.appease.controller 'coupons', ->
  $.appease.setupAndBindToAjax 'form#coupons-menu-form', $.fn.validate
  $.appease.setupAndBindToAjax 'form#new_coupon_info', ->
    @find('#expiry-date-input').datepicker
      format: 'yyyy-mm-dd'
      startDate: '0d'
      todayBtn: true
    @find('#coupon_info_image').pixelFileInput
      placeholder: 'Coupon image...'
    @validate()
    return
  return
