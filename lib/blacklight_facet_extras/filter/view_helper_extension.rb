module BlacklightFacetExtras::Filter::ViewHelperExtension
  def facet_values_for(solr_field)
    config = facet_filter_config(solr_field)
    facet_field = super(solr_field)
    return facet_field unless config

    items = facet_field.items.map do  |i|
      value = config.call(i.value)
      value = i.value if value === true
      next unless value
      BlacklightFacetExtras::FacetItem.new(i.value, i.hits, :display_label => value)
    end

    facet_field.items.replace(items)

    facet_field
  end

  def render_constraint_element(label, value, options = {})
    options[:classes] ||= []
    config = blacklight_filter_config.keys.select { |y| options[:classes].include? "filter-#{y.parameterize}" }.first
    return super(label, value, options) unless config

    display_label = blacklight_filter_config[config].call(value)
    display_label = value if label === true
    return ''.html_safe if label.blank?
    render(:partial => "catalog/filter_constraints_element", :locals => {:label => label, :display_label => display_label, :value => value, :options => options})
  end
end
