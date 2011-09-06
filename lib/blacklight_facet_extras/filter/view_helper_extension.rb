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
end
