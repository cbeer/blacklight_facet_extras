module BlacklightFacetExtras::Pivot::ViewHelperExtension
  def facet_partial_name(display_facet = nil)
    return "catalog/_facet_partials/pivot" if display_facet.is_a? RSolr::Ext::Response::Facets::PivotFacetField
    super 
  end


  # Get a FacetField object from the @response
  def facet_by_field_name solr_field
    case solr_field
      when String, Symbol
        @response.pivot_facets.select { |x| x.name == solr_field }.first
      when Blacklight::Configuration::FacetField
        @response.pivot_facets.select { |x| x.name == solr_field.field }.first
      else
        super 
    end
  end

  def render_facet_value(facet_solr_field, item, options = {})
    if item.field.respond_to? :parent
      return (link_to_unless(options[:suppress_link], item.value, add_pivot_facet_params_and_redirect(item), :class=>"facet_select label") + " " + render_facet_count(item.hits)).html_safe
    end

    super
  end

  def add_pivot_facet_params_and_redirect item
    p = params.dup
    p[:f] = (p[:f] || {}).dup # the command above is not deep in rails3, !@#$!@#$
    p[:f][item.field.name] = (p[:f][item.field.name] || []).dup
    p[:f][item.field.name].push(item.value)


    parent = item.try(:field).try(:parent)
    while parent
      p[:f][parent.field.name] = (p[:f][parent.field.name] || []).dup
      p[:f][parent.field.name].push(parent.value)

      parent = parent.try(:field).try(:parent)
    end

    p
  end
end
