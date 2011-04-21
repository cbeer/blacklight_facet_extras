# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject filter limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Filter::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :facet_filter_config
  end
    def facet_filter_config(solr_field)
      config = blacklight_filter_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_filter_config
      Blacklight.config[:facet][:filter] || {}
    end
end
