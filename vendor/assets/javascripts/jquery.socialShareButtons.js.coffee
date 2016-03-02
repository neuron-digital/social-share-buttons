#=require socialAdapters.js

$ ->
  PLUGIN_NAME = 'socialShareButtons'

  methods =
    init: (options) ->
      settings = $.extend true,
        selectors:
          tw: '.js-tw'
          fb: '.js-fb'
          gp: '.js-gp'
          vk: '.js-vk'
          ok: '.js-ok'
        selectorsCounter:
          tw: '.js-tw-counter'
          fb: '.js-fb-counter'
          gp: '.js-gp-counter'
          vk: '.js-vk-counter'
          ok: '.js-ok-counter'
        containerSelector: '.socials-share-buttons-container'
        url: location.href
        title: $("meta[property='og:title']").attr("content") or document.title
        image: $("meta[property='og:image']").attr("content")
        description: $("meta[name='description']").attr("content")
        fbAppId: $("meta[property='fb:app_id']").attr("content")
        isInitScroller: false
        scrollerOffset: ($socials) ->
          $socials.offset().top + $socials.height()
      , options

      @each ->
        $socials = $ @
        $container = $socials.find settings.containerSelector
        if $container.length
          new App.SocialTw $container, settings
          new App.SocialFb $container, settings
          new App.SocialVk $container, settings
          new App.SocialGp $container, settings
          new App.SocialOk $container, settings

        if settings.isInitScroller
          $(document).on "scroll.#{PLUGIN_NAME}", ->
            if $(window).scrollTop() > settings.scrollerOffset($socials)
              $container.addClass 'float'
            else
              $container.removeClass 'float'

          $(document).trigger('scroll')

    destroy: (options) ->
      settings = $.extend true,
        selectors:
          tw: '.js-tw'
          fb: '.js-fb'
          gp: '.js-gp'
          vk: '.js-vk'
          ok: '.js-ok'
        containerSelector: '.socials-share-buttons-container'
      , options

      $(document).off ".#{PLUGIN_NAME}"

      @each ->
        $socials = $ @
        $container = $socials.find settings.containerSelector

        $container.removeClass 'float'

        for _, selector of settings.selectors
          $selector = $container.find(selector)
          $selector.off ".#{PLUGIN_NAME}"

  $.fn.socialShareButtons = (method) ->
    if methods[method] then methods[method].apply @, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method then methods.init.apply @, arguments
    else $.error "Метод с именем #{method} не существует для jQuery.#{PLUGIN_NAME}"
