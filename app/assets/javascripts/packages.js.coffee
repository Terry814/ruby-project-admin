$.appease.controller 'packages', ->
  $ph  = $('.page-pricing-header')
  $img = $ph.find('> img')

  $(window).on 'resize', () ->
    $img.attr('style', '')
    if $img.height() < $ph.height()
      $img.css
        height: '100%'
        width: 'auto'
    return
  return