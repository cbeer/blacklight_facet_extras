module BlacklightFacetExtras::Query::ViewHelperExtension

  def facet_partial_name(display_facet = nil)
    return "catalog/_facet_partials/query" if blacklight_config.facet_fields[display_facet.name].query
    super 
  end
    

    def solr_query_to_a(solr_field)
      config = blacklight_config.facet_fields[solr_field].query
      return RSolr::Ext::Response::Facets::FacetField.new(solr_field, []) unless config and @response and @response["facet_counts"] and @response["facet_counts"]["facet_queries"] and @response["facet_counts"]["facet_queries"]

      arr = []
      config.each do |display_label, query|
        next unless @response["facet_counts"]["facet_queries"][query] and @response["facet_counts"]["facet_queries"][query] > 0 and  @response["facet_counts"]["facet_queries"][query] < @response.total
        arr <<  RSolr::Ext::Response::Facets::FacetItem.new(display_label,@response["facet_counts"]["facet_queries"][query])
      end

      RSolr::Ext::Response::Facets::FacetField.new(solr_field, arr)
    end
end
