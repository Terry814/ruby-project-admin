$.appease.controller 'quick_start', ->
  wizardForm = $('#quick-start-wizard')

  wizardForm.validate
    rules:
      'new_user[user][password_confirmation]':
        equalTo: '#new_user_user_password'

  wizardForm.steps
    bodyTag: 'section'

    transitionEffect: 'fade'
    enableKeyNavigation: false
    enablePagination: false

    onStepChanging: (event, currentIndex, newIndex) ->
      wizardForm.validate().settings.ignore = ':hidden'
      wizardForm.valid()

    onStepChanged: (event, currentIndex, newIndex) ->
      wizardForm.find('.wizard-next-step-button').click ->
        wizardForm.steps 'next'
        return
      return

  wizardForm.submit (event) ->
    wizardForm.valid()

  $('#appease-url-link').removeClass 'hidden'
  $('#appease-url-link').click (event) ->
    event.preventDefault()
    wizardForm.validate().settings.ignore = ':hidden'
    return unless wizardForm.valid()
    $.ajax
      url: @href
      data: 
        url:    $('#appease-url-field').val()
        format: 'js'
      dataType: 'script'
    return

  return