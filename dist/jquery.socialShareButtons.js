(function() {
  if (typeof jQuery === "undefined" || jQuery === null) {
    throw new Error("jQuery isn't defined");
  }

  $(function() {
    var PLUGIN_NAME, methods;
    PLUGIN_NAME = 'socialShareButtons';
    methods = {
      init: function(options) {
        var settings;
        settings = $.extend(true, {
          selectors: {
            tw: '.js-tw',
            fb: '.js-fb',
            gp: '.js-gp',
            vk: '.js-vk',
            ok: '.js-ok'
          },
          selectorsCounter: {
            tw: '.js-tw-counter',
            fb: '.js-fb-counter',
            gp: '.js-gp-counter',
            vk: '.js-vk-counter',
            ok: '.js-ok-counter'
          },
          callbackCounter: function(type, count) {},
          callbackClick: function(type) {},
          containerSelector: '.socials-share-buttons-container',
          url: location.href,
          title: $("meta[property='og:title']").attr("content") || document.title,
          image: $("meta[property='og:image']").attr("content"),
          description: $("meta[name='description']").attr("content"),
          fbAppId: $("meta[property='fb:app_id']").attr("content"),
          isInitScroller: false,
          scrollerOffset: function($socials) {
            return $socials.offset().top + $socials.height();
          }
        }, options);
        return this.each(function() {
          var $container, $socials;
          $socials = $(this);
          $container = $socials.find(settings.containerSelector);
          if ($container.length) {
            new App.SocialTw($container, settings);
            new App.SocialFb($container, settings);
            new App.SocialVk($container, settings);
            new App.SocialGp($container, settings);
            new App.SocialOk($container, settings);
          }
          if (settings.isInitScroller) {
            $(document).on("scroll." + PLUGIN_NAME, function() {
              if ($(window).scrollTop() > settings.scrollerOffset($socials)) {
                return $container.addClass('float');
              } else {
                return $container.removeClass('float');
              }
            });
            return $(document).trigger('scroll');
          }
        });
      },
      destroy: function(options) {
        var settings;
        settings = $.extend(true, {
          selectors: {
            tw: '.js-tw',
            fb: '.js-fb',
            gp: '.js-gp',
            vk: '.js-vk',
            ok: '.js-ok'
          },
          containerSelector: '.socials-share-buttons-container'
        }, options);
        $(document).off("." + PLUGIN_NAME);
        return this.each(function() {
          var $container, $selector, $socials, _, ref, results, selector;
          $socials = $(this);
          $container = $socials.find(settings.containerSelector);
          $container.removeClass('float');
          ref = settings.selectors;
          results = [];
          for (_ in ref) {
            selector = ref[_];
            $selector = $container.find(selector);
            results.push($selector.off("." + PLUGIN_NAME));
          }
          return results;
        });
      }
    };
    return $.fn.socialShareButtons = function(method) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === "object" || !method) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error("Метод с именем " + method + " не существует для jQuery." + PLUGIN_NAME);
      }
    };
  });

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.App || (window.App = {});

  App.SocialBase = (function() {
    var addhttp;

    SocialBase.prototype.PLUGIN_NAME = 'socialShareButtons';

    addhttp = function(url) {
      if (/^\/\//.test(url)) {
        url = "http:" + url;
      }
      return url;
    };

    function SocialBase($container1, settings1) {
      this.$container = $container1;
      this.settings = settings1;
      if (this.settings.selectors[this.type]) {
        this.$selector = this.$container.find(this.settings.selectors[this.type]);
        this.$selectorCounter = this.$container.find(this.settings.selectorsCounter[this.type]);
        this.callbackCounter = this.settings.callbackCounter;
        this.callbackClick = this.settings.callbackClick;
      }
      if (this.$selector.length) {
        this.url = encodeURIComponent(addhttp(this.settings.url));
        this.redirectUri = encodeURIComponent((addhttp(this.settings.url)) + "#close_window");
        this.title = encodeURIComponent(this.settings.title);
        this.description = encodeURIComponent(this.settings.description);
        this.image = encodeURIComponent(this.settings.image);
        if (this.$selectorCounter.length) {
          this.getCount();
        }
        this.initClick();
      }
    }

    SocialBase.prototype.getCount = function() {
      throw new Error('Unimplemented method');
    };

    SocialBase.prototype.initClick = function() {
      throw new Error('Unimplemented method');
    };

    return SocialBase;

  })();

  App.SocialOk = (function(superClass) {
    extend(SocialOk, superClass);

    SocialOk.prototype.type = 'ok';

    function SocialOk($container, settings) {
      SocialOk.__super__.constructor.call(this, $container, settings, this.type);
    }

    SocialOk.prototype.getCount = function() {
      var deferred, idx;
      deferred = $.Deferred();
      deferred.then((function(_this) {
        return function(number) {
          _this.$selectorCounter.text(number);
          return _this.callbackCounter(_this.type, number);
        };
      })(this));
      if (!$.fn.socialShareButtons.requestsOK) {
        $.fn.socialShareButtons.requestsOK = [];
        window.ODKL || (window.ODKL = {});
        window.ODKL.updateCount = function(idx, number) {
          return $.fn.socialShareButtons.requestsOK[idx].resolve(number);
        };
      }
      idx = $.fn.socialShareButtons.requestsOK.length;
      $.fn.socialShareButtons.requestsOK.push(deferred);
      return $.ajax({
        url: "https://connect.ok.ru/dk?st.cmd=extLike&uid=" + idx + "&ref=" + this.url,
        dataType: 'jsonp'
      });
    };

    SocialOk.prototype.initClick = function() {
      return this.$selector.on("click." + this.PLUGIN_NAME, (function(_this) {
        return function(e) {
          var winParams;
          e.preventDefault();
          winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0";
          open("https://ok.ru/dk?st.cmd=addShare&st._surl=" + _this.url + "&title=" + _this.title, "_blank", winParams);
          return _this.callbackClick(_this.type);
        };
      })(this));
    };

    return SocialOk;

  })(App.SocialBase);

  App.SocialGp = (function(superClass) {
    extend(SocialGp, superClass);

    SocialGp.prototype.type = 'gp';

    function SocialGp($container, settings) {
      SocialGp.__super__.constructor.call(this, $container, settings, this.type);
    }

    SocialGp.prototype.getCount = function() {
      return $.ajax({
        url: "https://share.yandex.ru/gpp.xml?url=" + this.url,
        dataType: 'json',
        success: (function(_this) {
          return function(data) {
            var result;
            result = data || 0;
            _this.$selectorCounter.text(result);
            return _this.callbackCounter(_this.type, result);
          };
        })(this)
      });
    };

    SocialGp.prototype.initClick = function() {
      return this.$selector.on("click." + this.PLUGIN_NAME, (function(_this) {
        return function(e) {
          var winParams;
          e.preventDefault();
          winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0";
          open("https://plus.google.com/share?url=" + _this.url, "_blank", winParams);
          return _this.callbackClick(_this.type);
        };
      })(this));
    };

    return SocialGp;

  })(App.SocialBase);

  App.SocialTw = (function(superClass) {
    extend(SocialTw, superClass);

    SocialTw.prototype.type = 'tw';

    function SocialTw($container, settings) {
      SocialTw.__super__.constructor.call(this, $container, settings, this.type);
    }

    SocialTw.prototype.getCount = function() {
      return 0;
    };

    SocialTw.prototype.initClick = function() {
      return this.$selector.on("click." + this.PLUGIN_NAME, (function(_this) {
        return function(e) {
          var winParams;
          e.preventDefault();
          winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0";
          open("https://twitter.com/intent/tweet?text=" + _this.title + "&url=" + _this.url, "_blank", winParams);
          return _this.callbackClick(_this.type);
        };
      })(this));
    };

    return SocialTw;

  })(App.SocialBase);

  App.SocialFb = (function(superClass) {
    extend(SocialFb, superClass);

    SocialFb.prototype.type = 'fb';

    function SocialFb($container, settings) {
      SocialFb.__super__.constructor.call(this, $container, settings, this.type);
    }

    SocialFb.prototype.getCount = function() {
      return $.ajax({
        url: "https://api.facebook.com/method/links.getStats?urls=" + this.url + "&format=json",
        dataType: 'jsonp',
        success: (function(_this) {
          return function(data) {
            var ref, result;
            result = ((ref = data[0]) != null ? ref.share_count : void 0) || 0;
            _this.$selectorCounter.text(result);
            return _this.callbackCounter(_this.type, result);
          };
        })(this)
      });
    };

    SocialFb.prototype.initClick = function() {
      return this.$selector.on("click." + this.PLUGIN_NAME, (function(_this) {
        return function(e) {
          var params, winParams;
          e.preventDefault();
          if (!_this.settings.fbAppId) {
            throw new Error("fbAppId is not defined");
          }
          params = "app_id=" + _this.settings.fbAppId + "&display=popup&redirect_uri=" + _this.redirectUri;
          params = params + "&link=" + _this.url + "&name=" + _this.title + "&description=" + _this.description + "&picture=" + _this.image;
          winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0";
          open("https://www.facebook.com/dialog/feed?" + params, "_blank", winParams);
          return _this.callbackClick(_this.type);
        };
      })(this));
    };

    return SocialFb;

  })(App.SocialBase);

  App.SocialVk = (function(superClass) {
    extend(SocialVk, superClass);

    SocialVk.prototype.type = 'vk';

    function SocialVk($container, settings) {
      SocialVk.__super__.constructor.call(this, $container, settings, this.type);
    }

    SocialVk.prototype.getCount = function() {
      var deferred, idx;
      deferred = $.Deferred();
      deferred.done((function(_this) {
        return function(number) {
          _this.$selectorCounter.text(number);
          return _this.callbackCounter(_this.type, number);
        };
      })(this));
      if (!$.fn.socialShareButtons.requestsVK) {
        $.fn.socialShareButtons.requestsVK = [];
        window.VK || (window.VK = {});
        VK.Share = {
          count: function(idx, number) {
            return $.fn.socialShareButtons.requestsVK[idx].resolve(number);
          }
        };
      }
      idx = $.fn.socialShareButtons.requestsVK.length;
      $.fn.socialShareButtons.requestsVK.push(deferred);
      return $.ajax({
        url: "https://vk.com/share.php?act=count&url=" + this.url + "&index=" + idx,
        dataType: 'jsonp'
      });
    };

    SocialVk.prototype.initClick = function() {
      return this.$selector.on("click." + this.PLUGIN_NAME, (function(_this) {
        return function(e) {
          var params, winParams;
          e.preventDefault();
          params = "url=" + _this.url + "&title=" + _this.title + "&description=" + _this.description + "&image=" + _this.image + "&noparse=true";
          winParams = "scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0";
          open("https://vk.com/share.php?" + params, "_blank", winParams);
          return _this.callbackClick(_this.type);
        };
      })(this));
    };

    return SocialVk;

  })(App.SocialBase);

}).call(this);
