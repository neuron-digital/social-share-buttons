# SocialShareButton
Gem for Ruby on Rails

Plugin loads the number of the sharing specified page and allows you to share it

## Demo
http://rusnovosti.ru/posts/361197

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
twSelector: '.js-tw'
vkSelector: '.js-vk'
fbSelector: '.js-fb'
containerSelector: '.post-likes'
url: location.href
isInitScroller: false
```

Example of DOM
```haml
.socials
  .post-likes
    .item
      %a.vk.js-vk{"data-text" => "Нравится", href: "#", rel: "noindex"}
        %i
      %span 0
    .item
      %a.tw.js-tw{"data-text" => "Твитнуть", href: "#", rel: "noindex"}
        %i
      %span 0
    .item
      %a.fb.js-fb{"data-text" => "Поделиться", href: "#", rel: "noindex"}
        %i
      %span 0
```