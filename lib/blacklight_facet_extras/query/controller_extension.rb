
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject query limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Query::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_query_facets_to_solr unless some_class.solr_search_params_logic.include? :add_query_facets_to_solr
    some_class.helper BlacklightFacetExtras::Query::ViewHelperExtension
  end

  def add_query_facets_to_solr(solr_parameters, user_parameters)
    blacklight_config.facet_fields.select { |key, config| config.query }.each do |key, config|
      solr_parameters[:"facet.field"].delete(key) if solr_parameters[:"facet.field"] 

      solr_parameters[:"facet.query"] ||= []
      
      config.query.each do |label, query|
        solr_parameters[:"facet.query"] << "{!key=#{label}}#{query}"
      end
    end
  end

  def facet_value_to_fq_string(facet_field, value)
    if config = blacklight_config.facet_fields[facet_field].query
      return config[value]
    end

    super
  end

  module ::RSolr::Ext::Response::Facets
    def query_facets #_with_pivot
      @query_facets ||= (
        facet_counts['facet_queries'].map do |query_key, hits|
          FacetItem.new query_key, hits
        end
      )
    end
  end
end
