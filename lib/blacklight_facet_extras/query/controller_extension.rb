
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
  def add_query_facets_to_solr(solr_parameters, user_parameters)
    blacklight_query_config.each do |k, config|
      solr_parameters[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") }.each do |x|
        v = solr_parameters[:fq].delete x
        value = v.gsub("{!raw f=#{k}}", "")
        value = config[value] if config[value]                  
        solr_parameters[:fq] << value
      end if solr_parameters[:fq]

      solr_parameters[:"facet.field"].select { |x| x == k }.each do |x|
        solr_parameters[:"facet.field"].delete x
      end if solr_parameters[:"facet.field"]

      solr_parameters[:"facet.query"] ||= []
      config.each do |label, query|
        solr_parameters[:"facet.query"] << query
      end
    end
  end

    def facet_query_config(solr_field)
      config = blacklight_query_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_query_config
      Blacklight.config[:facet][:query] || {}
    end
end
