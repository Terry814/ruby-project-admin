$.appease.controller 'product_menus', ->
  $.appease.setupAndBindToAjax 'form#product-menu-form', $.fn.validate
  $.appease.setupAndBindToAjax 'form#category-form', $.fn.validate
  $.appease.setupAndBindToAjax 'form#menu-item-form', ->
    @find('#product_menu_item_image').pixelFileInput
      placeholder: 'Product image...'
    @validate()
    return
