# Settings
# ------------------------------------------------
jQuery.fn.example = (options) ->
   defaults =
      sample_parameter:       true
   
   settings = jQuery.extend(defaults,options)
   
   $(this).each( ->
      this
   )