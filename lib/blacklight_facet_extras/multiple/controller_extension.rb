
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject tag limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Multiple::ControllerExtension
  def self.included(some_class)
    some_class.send :include, BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_inclusive_facets_to_solr unless some_class.solr_search_params_logic.include? :add_inclusive_facets_to_solr
    some_class.solr_search_params_logic << :add_multiple_facets_to_solr unless some_class.solr_search_params_logic.include? :add_multiple_facets_to_solr
    some_class.helper BlacklightFacetExtras::Multiple::ViewHelperExtension
  end

  ##
  # Add any existing facet limits, stored in app-level HTTP query
  # as :f, to solr as appropriate :fq query. 
  def add_inclusive_facets_to_solr(solr_parameters, user_params)      
    # :fq, map from :f_inclusive. 
    if ( user_params[:f_inclusive])
      f_request_params = user_params[:f_inclusive] 
      
      solr_parameters[:fq] ||= []
      f_request_params.each_pair do |facet_field, value_list|
        value_list ||= []
        value_list = [value_list] unless value_list.respond_to? :each
        solr_parameters[:fq] << "{!tag=#{facet_field.parameterize}}#{value_list.map { |value| "_query_:\"#{facet_value_to_fq_string(facet_field, value).gsub('"', '\\"')}\"" }.join(" OR ")})"
      end      
    end
  end

  def add_multiple_facets_to_solr(solr_parameters, user_parameters)
    return unless solr_parameters[:"facet.field"]

    solr_parameters[:"facet.field"].each_with_index.select { |field, index| blacklight_config.facet_fields[field].try(:multiple) }.each do |field, index|
      solr_parameters[:"facet.field"][index] = "{!ex=#{field.parameterize}}#{field}"
    end   
  end
end
