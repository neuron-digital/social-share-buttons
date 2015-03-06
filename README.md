# SocialShareButton
Gem for Ruby on Rails

Plugin loads the number of the sharing specified page and allows you to share it

## Demo
http://rusnovosti.ru/posts/361197
http://lifenews.ru/news/146165

## Install

Install gem in your Gemfile
```ruby
gem 'social_share_buttons', github: 'Go-Promo/social-share-buttons'
```

Requie jQuery-plugin in your js-assets
```coffee
#= require jquery.socialShareButtons
```

Use jQuery-plugin for your social button
```coffee
$('.socials').socialShareButtons()
```

## Using

Default plugin settings
```coffee
selectors:
  tw: '.js-tw'
  fb: '.js-fb'
  gp: '.js-gp'
  vk: '.js-vk'
  ok: '.js-ok'
containerSelector: '.socials-share-buttons-container'
url: location.href
title: document.title
image: $("meta[property='og:image']").attr("content")
description: $("meta[name='description']").attr("content")
isInitScroller: false
```

Example of DOM
```haml
.socials
  .socials-share-buttons-container
    .item
      %a.vk.js-vk{"data-text" => "Нравится", href: "#"}
        %i
      %span 0
    .item
      %a.tw.js-tw{"data-text" => "Твитнуть", href: "#"}
        %i
      %span 0
    .item
      %a.fb.js-fb{"data-text" => "Поделиться", href: "#"}
        %i
      %span 0
    .item
      %a.gp.js-gp{"data-text" => "Google+", href: "#"}
        %i
      %span 0
    .item
      %a.ok.js-ok{"data-text" => "Поделиться", href: "#"}
        %i
      %span 0
```