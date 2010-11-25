# Settings
# ------------------------------------------------
jQuery.fn.closeable = (options) ->
   defaults =
      close_selector:       'a.close'
      hidden_class:         'inactive'
   
   settings = jQuery.extend(defaults,options)
   
   $(this).each( ->
      module = $(this)
      module.after("<span id='#{module.attr('id')}_block' class='placehold'>")
      block = $("##{module.attr('id')}_block")
      block.height(module.height()+60)
      module.find(settings.close_selector).click( ->
         module.addClass(settings.hidden_class)
         setTimeout(( ->
            module.hide()
         ), 500)
         block.height(0)
      )
   )