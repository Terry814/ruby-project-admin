$.appease.controller 'pdf_files', ->
  $.appease.setupAndBindToAjax 'form#new_pdf_file_item', ->
    @find('#pdf_file_item_pdf_file').pixelFileInput
      placeholder: 'Select a PDF...'
    @validate()
    return
  return