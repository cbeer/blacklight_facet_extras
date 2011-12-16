
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject query limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Query::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_query_facets_to_solr
    some_class.helper_method :facet_query_config
    some_class.helper BlacklightFacetExtras::Query::ViewHelperExtension
  end

  def facet_value_to_fq_string(facet_field, value)
    if config = blacklight_config.facet_fields[facet_field].query
     return config[value]
    end

    super
  end

  def add_query_facets_to_solr(solr_parameters, user_parameters)
    blacklight_config.facet_fields.select { |key, config| config.query }.each do |key, config|
      solr_parameters[:"facet.field"].delete(key) if solr_parameters[:"facet.field"] 

      solr_parameters[:"facet.query"] ||= []
      
      config.query.each do |label, query|
        solr_parameters[:"facet.query"] << query
      end
    end
  end
end
