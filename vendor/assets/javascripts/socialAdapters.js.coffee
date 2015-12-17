window.App ||= {}

class App.SocialBase
  PLUGIN_NAME: 'socialShareButtons'

  constructor: (@$container, @settings) ->
    if @settings.selectors[@type]
      @$selector = @$container.find(@settings.selectors[@type])
      @$selectorCounter = @$container.find(@settings.selectorsCounter[@type])

    if @$selector.length
      @url = encodeURIComponent @settings.url
      @title = encodeURIComponent @settings.title
      @description = encodeURIComponent @settings.description
      @image = encodeURIComponent @settings.image

      if @$selectorCounter.length
        @getCount()

      @initClick()

  getCount: -> throw new Error('Unimplemented method')

  initClick: -> throw new Error('Unimplemented method')

class App.SocialOk extends App.SocialBase
  type: 'ok'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    deferred = $.Deferred()
    deferred.then (number) =>
      @$selectorCounter.text number

    unless $.fn.socialShareButtons.requestsOK
      $.fn.socialShareButtons.requestsOK = []

      window.ODKL ||= {}
      window.ODKL.updateCount = (idx, number) ->
        $.fn.socialShareButtons.requestsOK[idx].resolve number

    idx = $.fn.socialShareButtons.requestsOK.length
    $.fn.socialShareButtons.requestsOK.push deferred

    $.ajax
      url: "http://ok.ru/dk?st.cmd=extLike&uid=#{idx}&ref=#{@url}"
      dataType: 'jsonp'

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      open "http://ok.ru/dk?st.cmd=addShare&st._surl=#{@url}&title=#{@title}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

class App.SocialGp extends App.SocialBase
  type: 'gp'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    $.ajax
      url: "http://share.yandex.ru/gpp.xml?url=#{@url}"
      dataType: 'json'
      success: (data) =>
        result = data or 0
        @$selectorCounter.text result

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      open "https://plus.google.com/share?url=#{@url}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

class App.SocialTw extends App.SocialBase
  type: 'tw'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    # Твиттер удалили счётчики
    0

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      open "https://twitter.com/intent/tweet?text=#{@title}&url=#{@url}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

class App.SocialFb extends App.SocialBase
  type: 'fb'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    $.ajax
      url: "https://api.facebook.com/method/links.getStats?urls=#{@url}&format=json"
      dataType: 'jsonp'
      success: (data) =>
        result = data[0]?.share_count or 0
        @$selectorCounter.text result

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()

      throw new Error("fbAppId is not defined") if not @settings.fbAppId

      params = "app_id=#{@settings.fbAppId}&display=popup&redirect_uri=#{@url}&link=#{@url}&name=#{@title}&description=#{@description}&picture=#{@image}"
      open "https://www.facebook.com/dialog/feed?#{params}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"

class App.SocialVk extends App.SocialBase
  type: 'vk'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    deferred = $.Deferred()
    deferred.done (number) =>
      @$selectorCounter.text number

    unless $.fn.socialShareButtons.requestsVK
      $.fn.socialShareButtons.requestsVK = []

      window.VK ||= {}
      VK.Share = count: (idx, number) ->
        $.fn.socialShareButtons.requestsVK[idx].resolve number

    idx = $.fn.socialShareButtons.requestsVK.length
    $.fn.socialShareButtons.requestsVK.push deferred

    $.ajax
      url: "https://vk.com/share.php?act=count&url=#{@url}&index=#{idx}"
      dataType: 'jsonp'

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      params = "url=#{@url}&title=#{@title}&description=#{@description}&image=#{@image}&noparse=true"
      open "https://vk.com/share.php?#{params}", "_blank", "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
