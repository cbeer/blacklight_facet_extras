require 'rubygems'
require 'bundler'

Bundler.require :default, :development

require 'blacklight/engine'
require 'rsolr'
require 'rsolr-ext'
require 'rsolr-ext/response'
require 'capybara/rspec'
Combustion.initialize!


# Setup blacklight environment
Blacklight.solr_config = { :url => 'http://127.0.0.1:8983/solr' }

require 'vcr'

VCR.config do |config|
  config.stub_with :fakeweb
  config.cassette_library_dir = 'spec/vcr_cassettes'
end

require 'rspec/rails'
require 'capybara/rails'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros

end

