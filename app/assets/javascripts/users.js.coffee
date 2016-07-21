$.appease.controller 'users', ->
  $('select[name=ad_frequency]').change ->
    app_id = $(@).data 'app-id'
    $.ajax
      method: 'PUT'
      url: "#{app_id}/ad_frequency"
      data: 
        ad_frequency: $(@).val()
        format: 'js'
      dataType: 'script'
    return
  return