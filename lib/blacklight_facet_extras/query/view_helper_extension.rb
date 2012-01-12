module BlacklightFacetExtras::Query::ViewHelperExtension
  # Get a FacetField object from the @response
  def facet_by_field_name solr_field
    case solr_field
      when String, Symbol
        config = facet_configuration_for_field(solr_field)
        return facet_by_field_name(config)  if config.query
      when Blacklight::Configuration::FacetField
        if solr_field.query
          items = @response.query_facets.select { |x| solr_field.query.keys.include? x.value }
          field = RSolr::Ext::Response::Facets::FacetField.new solr_field.field, items
          return field
        end
    end
    return super
  end
end
