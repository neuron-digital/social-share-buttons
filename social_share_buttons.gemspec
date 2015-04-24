$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "social_share_buttons/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "social_share_buttons"
  s.version     = SocialShareButtons::VERSION
  s.authors     = ["Go-Promo"]
  s.email       = ["aavdeev@go-promo.ru"]
  s.homepage    = "https://github.com/Go-Promo/social-share-buttons"
  s.summary     = "jQuery-plugin for social share buttons"
  s.description = "Plugin loads the number of the sharing specified page and allows you to share it"
  s.license     = "MIT"

  s.files = Dir["{lib,vendor}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
end
