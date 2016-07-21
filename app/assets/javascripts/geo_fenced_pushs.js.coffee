$.appease.controller 'geo_fenced_pushs', ->
  $.appease.setupAndBindToAjax 'form#new_geo_message', ->
    options =
      icons:
        time: 'fa fa-clock-o'
        date: 'fa fa-calendar'
        up: 'fa fa-arrow-up'
        down: 'fa fa-arrow-down'
      useSeconds: false
      minDate: new Date()
      format: 'YYYY-MM-DD hh:mm:00 A'

    startTimeInput = $('#start-time-input')
    endTimeInput = $('#end-time-input')

    startTimeInput.datetimepicker options
    endTimeInput.datetimepicker options

    startTimeInput.on 'dp.change', (e) ->
      endTimeInput.data('DateTimePicker').setMinDate e.date
      return

    endTimeInput.on 'dp.change', (e) ->
      startTimeInput.data('DateTimePicker').setMaxDate e.date
      return

    for input in [startTimeInput, endTimeInput]
      if (initialVal = input.data('initial'))
        input.data('DateTimePicker').setDate(moment(initialVal));

    @validate()
    return
