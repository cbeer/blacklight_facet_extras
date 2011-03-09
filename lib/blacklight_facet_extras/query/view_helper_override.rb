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
        next unless @response["facet_counts"]["facet_queries"][query] and @response["facet_counts"]["facet_queries"][query] > 0
        arr << BlacklightFacetExtras::Query::FacetItem.new(query,@response["facet_counts"]["facet_queries"][query], :display_label => display_label) 
      end

      RSolr::Ext::Response::Facets::FacetField.new(solr_field, arr)
    end

    def render_facet_value(facet_solr_field, item, options ={})
      if item.is_a? BlacklightFacetExtras::Query::FacetItem
        (link_to_unless(options[:suppress_link], item.display_label || item.value , add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select label") + " " + render_facet_count(item.hits)).html_safe
      else
        super(facet_solr_field, item, options ={})
      end
    end
end
