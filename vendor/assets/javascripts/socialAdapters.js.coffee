window.App ||= {}

class App.SocialBase
  PLUGIN_NAME: 'socialShareButtons'

  addhttp = (url) ->
    if /^\/\//.test(url)
      url = "http:#{url}"
    url

  constructor: (@$container, @settings) ->
    if @settings.selectors[@type]
      @$selector = @$container.find(@settings.selectors[@type])
      @$selectorCounter = @$container.find(@settings.selectorsCounter[@type])
      @callbackCounter = @settings.callbackCounter
      @callbackClick = @settings.callbackClick

    if @$selector.length
      @url = encodeURIComponent addhttp(@settings.url)
      @redirectUri = encodeURIComponent "#{addhttp(@settings.url)}#close_window"
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
      @callbackCounter @type, number

    unless $.fn.socialShareButtons.requestsOK
      $.fn.socialShareButtons.requestsOK = []

      window.ODKL ||= {}
      window.ODKL.updateCount = (idx, number) ->
        $.fn.socialShareButtons.requestsOK[idx].resolve number

    idx = $.fn.socialShareButtons.requestsOK.length
    $.fn.socialShareButtons.requestsOK.push deferred

    $.ajax
      url: "https://connect.ok.ru/dk?st.cmd=extLike&uid=#{idx}&ref=#{@url}"
      dataType: 'jsonp'

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "https://ok.ru/dk?st.cmd=addShare&st._surl=#{@url}&title=#{@title}", "_blank", winParams

      @callbackClick @type

class App.SocialMail extends App.SocialBase
  type: 'mail'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    # CORS
    0

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "http://connect.mail.ru/share?share_url=#{@url}&title=#{@title}&description=#{@description}&imageurl=#{@image}", "_blank", winParams

      @callbackClick @type

class App.SocialGp extends App.SocialBase
  type: 'gp'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    # CORS
    0

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()
      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "https://plus.google.com/share?url=#{@url}", "_blank", winParams

      @callbackClick @type

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
      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "https://twitter.com/intent/tweet?text=#{@title}&url=#{@url}", "_blank", winParams

      @callbackClick @type

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
        @callbackCounter @type, result

  initClick: ->
    @$selector.on "click.#{@PLUGIN_NAME}", (e) =>
      e.preventDefault()

      throw new Error("fbAppId is not defined") if not @settings.fbAppId

      params = "app_id=#{@settings.fbAppId}&display=popup&redirect_uri=#{@redirectUri}"
      params = "#{params}&link=#{@url}&name=#{@title}&description=#{@description}&picture=#{@image}"

      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "https://www.facebook.com/dialog/feed?#{params}", "_blank", winParams

      @callbackClick @type

class App.SocialVk extends App.SocialBase
  type: 'vk'

  constructor: ($container, settings) ->
    super $container, settings, @type

  getCount: ->
    deferred = $.Deferred()
    deferred.done (number) =>
      @$selectorCounter.text number
      @callbackCounter @type, number

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
      if @settings.description.length > 80
        @description = "#{@settings.description.substr(0, 80)}..."
      if @settings.title.length > 80
        @title = "#{@settings.title.substr(0, 80)}..."

      params = "url=#{@url}&title=#{@title}&description=#{@description}&image=#{@image}&noparse=true"
      if @settings.isVkParse
        params = "url=#{@url}"

      winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0"
      open "https://vk.com/share.php?#{params}", "_blank", winParams

      @callbackClick @type
