$.appease.controller 'menu_cover_images', ->
  $('input[name="application_info[cover_image_style]"]', 'form#cover-image-style').change ->
    $('form#cover-image-style').submit()
    return

  $('#cover-image-upload').dropzone
    paramName: 'application_info[cover_image]'
    maxFilesize: 1 # MB
    maxFiles: 1
    acceptedFiles: 'image/*'
    addRemoveLinks: true
    thumbnailHeight: 250
    thumbnailWidth: 650

    dictResponseError: "Can't upload file!"
    autoProcessQueue: true

    previewTemplate: '''
      <div class="dz-preview dz-file-preview">
        <div class="dz-details">
          <div class="dz-thumbnail-wrapper">
            <div class="dz-thumbnail">
              <img data-dz-thumbnail>
              <span class="dz-nopreview">No preview</span>
              <div class="dz-success-mark">
                <i class="fa fa-check-circle-o"></i>
              </div>
              <div class="dz-error-mark">
                <i class="fa fa-times-circle-o"></i>
              </div>
              <div class="dz-error-message">
                <span data-dz-errormessage></span>
              </div>
            </div>
          </div>
        </div>
        <div class="progress progress-striped active">
          <div class="progress-bar progress-bar-success" data-dz-uploadprogress></div>
          </div>
        </div>
      </div>
      '''

    init: ->
      @on 'maxfilesexceeded', (file) ->
        @removeAllFiles()
        @addFile(file)
        return

      @on 'removedfile', (file) ->
        $.ajax
          url: $(@element).attr 'action'
          type: 'DELETE'
          dataType: 'json'
          success: ->
            return
        return

      current = $(@element).data 'current'
      mockFile = 
        accepted: true
        size: 1
      @emit 'addedfile', mockFile
      @files.push mockFile
      @emit 'thumbnail', mockFile, current
      @emit 'uploadprogress', mockFile, 100, 1
      return
  return