jQuery.validator.addMethod 'opentable_url', ((value, element) ->
  @optional(element) or /^https?:\/\/(www\.)?(m\.)?opentable.com/.test(value)
), 'Please enter OpenTable url'

$.appease.controller 'open_tables', ->
  $.appease.setupAndBindToAjax 'form#opentable-form', ->
    @validate
      rules: 
        'open_table[url]':
          opentable_url: true
    return
  return