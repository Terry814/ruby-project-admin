$.appease.controller 'social_streams', ->
  $.appease.setupAndBindToAjax 'form.edit_social_stream', $.fn.validate
  $.appease.setupAndBindToAjax 'form#new_social_stream', $.fn.validate
  $(document).on 'shown.bs.modal', '#new-social-source-modal', ->
    $('form.new_social_source_account').each ->
      $(@).validate()
      return
    return
  return