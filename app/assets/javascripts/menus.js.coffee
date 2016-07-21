$.appease.controller 'menus', ->
  updateHiddenInput = ->
    $('#hidden-menu-items-input').empty()
    sortArray = $('#menu-items-sort').sortable('serialize').split('&')
    for item in sortArray
      nameAndVal = item.split('=')
      $('#hidden-menu-items-input').append $('<input>').attr('type', 'hidden').attr('name', nameAndVal.shift()).val(nameAndVal.shift())
    return

  $('#menu-items-sort').disableSelection()
  $('#menu-items-sort').sortable
    axis: 'y'
    handle: 'h3'
    stop: (event, ui) ->
      ui.item.children('h3').triggerHandler('focusout')
      updateHiddenInput()
      return

  updateHiddenInput()
  return