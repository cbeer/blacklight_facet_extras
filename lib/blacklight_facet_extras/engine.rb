require 'blacklight'
require 'blacklight_facet_extras'
require 'rails'

module BlacklightFacetExtras
  class Engine < Rails::Engine
    config.to_prepare do
      unless BlacklightFacetExtras.omit_inject[:routes]
        Blacklight::Routes.send(:include, BlacklightFacetExtras::RouteSets)
      end
    end
  end
end

