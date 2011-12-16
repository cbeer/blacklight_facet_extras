
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject tag limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Tag::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_tag_facets_to_solr
    some_class.helper_method :facet_tag_config
    some_class.helper BlacklightFacetExtras::Tag::ViewHelperExtension
  end

  def facet_value_to_fq_string(facet_field, value)
    if tag = blacklight_config.facet_fields[facet_field].tag
      tag = facet_field.parameterize if tag === true
      return "{!tag=#{tag}} _query_:\"#{super}\""
    end

    super
  end

  def add_tag_facets_to_solr(solr_parameters, user_parameters)
    return unless solr_parameters[:"facet.field"]

    solr_parameters[:"facet.field"].each_with_index.select { |field, index| blacklight_config.facet_fields[field].ex }.each do |field, index|
      ex = blacklight_config.facet_fields[field].ex
      ex = value.parameterize if ex === true

      solr_parameters[:"facet.field"][index] = "{!ex=#{ex}}#{field}"
    end   
  end
end
