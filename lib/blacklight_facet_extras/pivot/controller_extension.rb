
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject pivot limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Pivot::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.helper_method :facet_pivot_config
    some_class.solr_search_params_logic << :add_pivot_facets_to_solr
    some_class.helper BlacklightFacetExtras::Pivot::ViewHelperExtension
  end
  def add_pivot_facets_to_solr(solr_parameters, user_parameters)

    blacklight_pivot_config.each do |k, config|
      solr_parameters[:"facet.field"].select { |x| x == k }.each do |x|
        solr_parameters[:"facet.field"].delete x
      end if solr_parameters[:"facet.field"]

      solr_parameters[:"facet.pivot"] ||= []
      solr_parameters[:"facet.pivot"] << config.join(",")
    end

    solr_parameters
  end

    def facet_pivot_config(solr_field)
      config = blacklight_pivot_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_pivot_config
      Blacklight.config[:facet][:pivot] || {}
    end
end
