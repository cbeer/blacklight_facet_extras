module BlacklightFacetExtras::Pivot::ViewHelperOverride

    def render_facet_limit(solr_field)
      config = facet_pivot_config(solr_field)
      if ( config )
        render(:partial => "catalog/_facet_partials/pivot", :locals=> {:solr_field => solr_field })
      else
        super(solr_field)
      end
    end
    def solr_pivot_to_a(solr_field)
      config = facet_pivot_config(solr_field)
      return RSolr::Ext::Response::Facets::FacetField.new(solr_field, []) unless config and @response and @response["facet_counts"] and @response["facet_counts"]["facet_pivot"] and @response["facet_counts"]["facet_pivot"]

      arr = []
      pivot_field = config.join(",")

      data = @response["facet_counts"]["facet_pivot"][pivot_field]
      return RSolr::Ext::Response::Facets::FacetField.new(solr_field, []) unless data

      data.each do |parent|
        item = BlacklightFacetExtras::Pivot::FacetItem.new(parent['value'], parent['count'], :field => solr_field)

        item.facets ||= []
        parent['pivot'].each do |child|
          label = child['value'].split(" / ").last


          item.facets << BlacklightFacetExtras::Pivot::FacetItem.new(child['value'], child['count'], :display_label => label, :field => child['field'], :parent => item)
        end


        arr << item
      end

      RSolr::Ext::Response::Facets::FacetField.new(solr_field, arr)
    end

    def render_facet_value(facet_solr_field, item, options ={})
      if item.is_a? BlacklightFacetExtras::Pivot::FacetItem
        p = add_facet_params_and_redirect(item.field || facet_solr_field, item.value)

        if item.parent
          p[:f][item.parent.field] ||= []
          p[:f][item.parent.field].push(item.parent.value)
        end

        (link_to_unless(options[:suppress_link], item.display_label || item.value , p, :class=>"facet_select label") + " " + render_facet_count(item.hits)).html_safe
      else
        super(facet_solr_field, item, options ={})
      end
    end
end
