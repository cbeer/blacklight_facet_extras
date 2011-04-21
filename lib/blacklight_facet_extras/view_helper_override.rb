module BlacklightFacetExtras::ViewHelperOverride
  def render_facet_value(facet_solr_field, item, options ={})
    if item.respond_to? :display_label
      (link_to_unless(options[:suppress_link], item.display_label || item.value , add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select label") + " " + render_facet_count(item.hits)).html_safe
    else
      super(facet_solr_field, item, options ={})
    end
  end

  def facet_values_for(solr_field)
    @response.facets.detect {|f| f.name == solr_field}
  end
end

