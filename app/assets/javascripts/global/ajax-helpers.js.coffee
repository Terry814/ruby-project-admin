showFlashMessages = (jqXHR) ->
  return if !jqXHR or !jqXHR.getResponseHeader
  flash = jqXHR.getResponseHeader('X-Flash-Messages')
  flash = JSON.parse(flash)
  return unless flash
  $.each flash, (key, message) ->
    title = key.charAt(0).toUpperCase() + key.substring(1)
    duration = if message.length > 70 then 7000 else 3500
    size = if message.length > 70 then 'large' else 'medium'
    $.growl
      message: message
      style: key
      title: title
      duration: duration
      size: size
    return
  return

$(document).ajaxComplete (event, xhr, settings) ->
  showFlashMessages xhr
  return

$(document).ajaxSend ->
  $('#data-modal-confirm-dialog').modal 'hide'
  return

$(document).ajaxError (event, jqXHR, settings) ->
  if !jqXHR or !jqXHR.getResponseHeader
    return
  $.growl
    title: jqXHR.statusText
    style: 'error'
    message: ''
  return

$.fn.ae_removeWithFadeOut = (dur) ->
  @fadeOut dur, ->
    $(@).remove()
    return
  return

$.fn.once = (event, handler) ->
  @each ->
    $(@).off(event).on(event, handler)
    return
