$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "social_share_buttons/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "social_share_buttons"
  s.version     = SocialShareButtons::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SocialShareButtons."
  s.description = "TODO: Description of SocialShareButtons."
  s.license     = "MIT"

  s.files = Dir["{lib,vendor}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"
end
