module BlacklightFacetExtras::Range::ViewHelperExtension

  def facet_partial_name(display_facet = nil)
    return "catalog/_facet_partials/range" if blacklight_config.facet_fields[display_facet.name].rangex
    super 
  end

    def solr_range_to_a(solr_field)
      config = facet_range_config(solr_field)
      return RSolr::Ext::Response::Facets::FacetField.new(solr_field,[]) unless config and @response and @response["facet_counts"] and @response["facet_counts"]["facet_ranges"] and @response["facet_counts"]["facet_ranges"][solr_field]

      data = @response["facet_counts"]["facet_ranges"][solr_field]

      arr = []

      arr << BlacklightFacetExtras::Range::FacetItem.new("before", data[:before], :from => '*', :to => data[:start]) if data[:before] > 0

      last = 0
      range = data[:counts].each_slice(2).map { |value, hits| BlacklightFacetExtras::Range::FacetItem.new(value,hits) }

      if range.length > 1
      
      range.each_cons(2) do |item, peek| 
        item.from = item.value
        item.to = peek.value
        item.display_label = "#{item.from} - #{item.to}"
        arr << item
      end

      arr << range.last.tap { |x| x.from = x.value; x.to = data[:end]; x.display_label = "#{x.from} - #{x.to}" }
      end

      arr << BlacklightFacetExtras::Range::FacetItem.new("after", data[:after], :from => data[:end], :to => '*') if data[:after] > 0
      RSolr::Ext::Response::Facets::FacetField.new(solr_field, arr)
    end
end
