$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  modal_class = link.attr('modal-class') || 'warning'
  title = link.attr 'modal-title'
  $link = link.clone()
    # We don't necessarily want the same styling as the original link/button.
    .removeAttr('class')
    # We don't want to pop up another confirmation (recursion)
    .removeAttr('data-confirm')
    # We want a button
    .addClass('btn').addClass('btn-' + modal_class)
    # We want it to sound confirmy
    .html("OK")

  html = """
    <div id="data-modal-confirm-dialog" class="modal modal-alert modal-#{modal_class} fade" style="display: none;" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <i class="fa fa-warning"></i>
          </div>
          <div class="modal-title">
            <p>#{title}</p>
          </div>
          <div class="modal-body">
            <p>#{message}</p>
          </div>
          <div class="modal-footer">
          </div>
        </div> <!-- / .modal-content -->
      </div> <!-- / .modal-dialog -->
    </div>
         """
  $modal_html = $(html)
  $modal_html.find('.modal-footer').append($link)
  $modal_html.modal()

$(document).on 'hidden.bs.modal', '.modal', ->
  @remove()
  return
