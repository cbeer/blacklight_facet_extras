module BlacklightFacetExtras::Query::ViewHelperOverride

    def render_facet_limit(solr_field)
      config = facet_query_config(solr_field)
      if ( config )
        render(:partial => "catalog/_facet_partials/query", :locals=> {:solr_field => solr_field })
      else
        super(solr_field)
      end
    end

    def solr_query_to_a(solr_field)
      config = facet_query_config(solr_field)
      return RSolr::Ext::Response::Facets::FacetField.new(solr_field, []) unless config and @response and @response["facet_counts"] and @response["facet_counts"]["facet_queries"] and @response["facet_counts"]["facet_queries"]

      arr = []
      config.each do |display_label, query|
        next unless @response["facet_counts"]["facet_queries"][query] and @response["facet_counts"]["facet_queries"][query] > 0 and  @response["facet_counts"]["facet_queries"][query] < @response.total
        arr <<  RSolr::Ext::Response::Facets::FacetItem.new(display_label,@response["facet_counts"]["facet_queries"][query])
      end

      RSolr::Ext::Response::Facets::FacetField.new(solr_field, arr)
    end
end
