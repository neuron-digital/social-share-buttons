#= require jquery

$ ->
  PLUGIN_NAME = 'socialShareButtons'

  methods =
    init: (options) ->
      settings = $.extend true,
        {}
      , options

      @each ->
        $block = $ @

  $.fn.socialShareButtons = (method) ->
    if methods[method] then methods[method].apply @, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method then methods.init.apply @, arguments
    else $.error "Метод с именем #{method} не существует для jQuery.#{PLUGIN_NAME}"