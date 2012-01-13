
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject tag limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Single::ControllerExtension
  def self.included(some_class)
    some_class.send :include, BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_single_facets_to_solr unless some_class.solr_search_params_logic.include? :add_multiple_facets_to_solr
    some_class.helper BlacklightFacetExtras::Single::ViewHelperExtension
  end

  def facet_value_to_fq_string(facet_field, value)
    if tag = blacklight_config.facet_fields[facet_field].single
      return "{!tag=#{facet_field.parameterize}} _query_:\"#{super}\""
    end

    super
  end

  def add_single_facets_to_solr(solr_parameters, user_parameters)
    return unless solr_parameters[:"facet.field"]

    solr_parameters[:"facet.field"].each_with_index.select { |field, index| blacklight_config.facet_fields[field].try(:single) }.each do |field, index|
      solr_parameters[:"facet.field"][index] = "{!ex=#{field.parameterize}}#{field}"
    end   
  end
end
