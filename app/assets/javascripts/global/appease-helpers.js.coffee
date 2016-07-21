$.appease =
  setupAndBindToAjax: (selector, setup) ->
    checkAndSetup = ->
      return if !@length || @data 'appease-initialized'
      @data 'appease-initialized', true
      setup.call @
      return

    checkAndSetup.call $(selector)

    $(document).on 'ajaxComplete.appease_controller', (_, jqXHR, o) ->
      if jqXHR.getResponseHeader('Content-Type').match(/text\/javascript/i)
        checkAndSetup.call $(selector)
      return
    return

  controller: (name, js) ->
    selector = ".#{name}"
    $(document).on 'appease:page_load', ->
      if $(selector).length
        $(document).off 'ajaxComplete.appease_controller'
        js.call $(selector)
      return
    return