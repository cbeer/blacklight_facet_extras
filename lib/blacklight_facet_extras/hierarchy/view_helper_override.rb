module BlacklightFacetExtras::Hierarchy::ViewHelperOverride
  def facet_values_for(solr_field)
    config = facet_hierarchy_config(solr_field)
    facet_field = super(solr_field)
    return facet_field unless config

    items = facet_field.items.map do  |i|
      value = i.value.split('/').last
      BlacklightFacetExtras::FacetItem.new(i.value.split("/", 2).last, i.hits, :display_label => value)
    end

    facet_field.items.replace(items)

    facet_field
  end

  def add_facet_params field, value
    p = super(field, value) 
    p[:f][field] = [p[:f][field].last] if facet_hierarchy_config(field)
    p  
  end

  def remove_facet_params(field, value, source_params=params)
    p = super(field, value, source_params) 

    if facet_hierarchy_config(field)
      hierarchy = value.split("/")
      hierarchy.pop
      unless hierarchy.empty?
        p[:f][field] ||= []
        p[:f][field] << hierarchy.join("/") 
      end
    end
    p
  end

  def render_constraint_element(label, value, options = {})
    return super(label, value, options) unless options[:classes].any? { |x| blacklight_hierarchy_config.keys.map { |y| "filter-#{y.parameterize}" }.include? x }

    render(:partial => "catalog/hierarchical_constraints_element", :locals => {:label => label, :value => value, :options => options})
  end
end
