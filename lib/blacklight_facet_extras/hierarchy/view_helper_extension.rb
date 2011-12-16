module BlacklightFacetExtras::Hierarchy::ViewHelperExtension

  def facet_partial_name(display_facet = nil)
    return "catalog/_facet_partials/hierarchy" if blacklight_config.facet_fields[display_facet.name].hierarchy
    super 
  end

  def render_facet_value(facet_solr_field, item, options = {})
    if blacklight_config.facet_fields[facet_solr_field].hierarchy
      return (link_to_unless(options[:suppress_link], item.value.split('/').last, add_facet_params_and_redirect(facet_solr_field, item.value.split('/', 2).last), :class=>"facet_select label") + " " + render_facet_count(item.hits)).html_safe
    end
    
    super
  end

  def add_facet_params field, value
    p = super 
    p[:f][field] = [p[:f][field].last] if blacklight_config.facet_fields[field].hierarchy
    p  
  end

  def remove_facet_params(field, value, source_params=params)
    return super unless blacklight_config.facet_fields[field].hierarchy

    p = super

    hierarchy = value.split("/")
    hierarchy.pop
    unless hierarchy.empty?
      p[:f][field] ||= []
      p[:f][field] << hierarchy.join("/") 
    end
    p
  end

  def render_constraint_element(label, value, options = {})
    options[:classes] ||= []
    return super unless options[:classes].any? { |x| blacklight_config.facet_fields.select { |key, config| config.hierarchy }.keys.map { |y| "filter-#{y.parameterize}" }.include? x }

    return ''.html_safe if value.blank?
    render(:partial => "catalog/hierarchical_constraints_element", :locals => {:label => label, :value => value, :options => options})
  end
end
