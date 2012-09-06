 # -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/blacklight_facet_extras/version")

Gem::Specification.new do |s|
  s.name = "blacklight_facet_extras"
  s.version = BlacklightFacetExtras::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Chris Beer"]
  s.email = ["chris_beer@wgbh.org"]
  s.homepage    = "http://projectblacklight.org/"
  s.summary = "Blacklight facet extras plugin"

  s.rubyforge_project = "blacklight"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "blacklight", "~> 3.5"

  #s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "vcr"
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'launchy'
end

