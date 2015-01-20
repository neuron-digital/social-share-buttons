#= require jquery

$ ->
  PLUGIN_NAME = 'socialShareButtons'

  methods =
    init: (options) ->
      settings = $.extend true,
        twSelector: '.js-tw'
        vkSelector: '.js-vk'
        fbSelector: '.js-fb'
        containerSelector: '.post-likes'
        url: location.href
        isInitScroller: false
      , options

      @each ->
        $socials = $ @
        $postLikes = $socials.find(settings.containerSelector)
        if $postLikes.length
          new SocialTw $(settings.twSelector), settings.url
          new SocialFb $(settings.fbSelector), settings.url
          new SocialVk $(settings.vkSelector), settings.url

          if settings.isInitScroller
            initScroller $socials, $postLikes

  initScroller = ($socials, $postLikes) ->
    checkSocialScroll = ->
      if $(window).scrollTop() > offset
        $postLikes.addClass 'float'
      else
        $postLikes.removeClass 'float'

    offset = $socials.offset().top + $socials.height()

    $(document).on 'scroll', checkSocialScroll

    checkSocialScroll()

  class SocialBase
    constructor: (@$selector, @url) ->
      @getCount()
      @initClick()

    getCount: -> throw Error 'unimplemented method'

    initClick: -> throw Error 'unimplemented method'

  class SocialTw extends SocialBase
    getCount: ->
      $.ajax
        url: "https://cdn.api.twitter.com/1/urls/count.json?url=#{@url}"
        dataType: 'jsonp'
        success: (data) =>
          result = data.count or 0
          @$selector.parent().find("span").text result

    initClick: ->
      @$selector.on 'click', (e) =>
        e.preventDefault()
        title = encodeURIComponent document.title
        open "https://twitter.com/intent/tweet?text=#{title}&url=#{@url}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

  class SocialFb extends SocialBase
    getCount: ->
      $.ajax
        url: "https://api.facebook.com/method/links.getStats?urls=#{@url}&format=json"
        dataType: 'jsonp'
        success: (data) =>
          result = data[0]?.share_count or 0
          @$selector.parent().find("span").text result

    initClick: ->
      @$selector.on 'click', (e) =>
        e.preventDefault()
        summary = encodeURIComponent $("meta[property='og:description']").attr("content")
        image = encodeURIComponent $("meta[property='og:image']").attr("content")
        title = encodeURIComponent document.title
        params = "s=100&p[url]=#{@url}&p[title]=#{title}&p[summary]=#{summary}&p[images][0]=#{image}"
        open "http://www.facebook.com/sharer.php?m2w&#{params}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

  class SocialVk extends SocialBase
    getCount: ->
      window.VK ||= {}
      window.VK.Share = count: (idx, number) =>
        @$selector.parent().find('span').text number
      $.ajax
        url: "http://vk.com/share.php?act=count&index=1&url=#{@url}"
        dataType: 'jsonp'

    initClick: ->
      @$selector.on 'click', (e) =>
        e.preventDefault()
        title = encodeURIComponent document.title
        open "http://vk.com/share.php?url=#{@url}&title=#{title}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

  $.fn.socialShareButtons = (method) ->
    if methods[method] then methods[method].apply @, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method then methods.init.apply @, arguments
    else $.error "Метод с именем #{method} не существует для jQuery.#{PLUGIN_NAME}"