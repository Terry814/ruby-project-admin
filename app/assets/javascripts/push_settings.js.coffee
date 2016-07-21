$.appease.controller 'push_settings', ->
  $.appease.setupAndBindToAjax '.upload-certificate', ->
    @click ->
      $(@).closest('form').find('#certificate_file').click()
      return false
    return
  $.appease.setupAndBindToAjax 'input[name="certificate[file]"]', ->
    @change ->
      $(@).closest('form').submit()
      return false
    return
  return
