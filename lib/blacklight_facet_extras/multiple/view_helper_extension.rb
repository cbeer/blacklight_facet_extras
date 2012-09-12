module BlacklightFacetExtras::Multiple::ViewHelperExtension
  # adds the value and/or field to params[:f_inclusive]
  # Does NOT remove request keys and otherwise ensure that the hash
  # is suitable for a redirect. See
  # add_facet_params_and_redirect
  def add_facet_params(field, value)
    return super unless blacklight_config.facet_fields[field].multiple

    p = params.dup
    p[:f_inclusive] = (p[:f_inclusive] || {}).dup # the command above is not deep in rails3, !@#$!@#$
    p[:f_inclusive][field] = (p[:f_inclusive][field] || []).dup
    p[:f_inclusive][field].push(value)
    p
  end

  # copies the current params (or whatever is passed in as the 3rd arg)
  # removes the field value from params[:f]
  # removes the field if there are no more values in params[:f][field]
  # removes additional params (page, id, etc..)
  def remove_facet_params(field, value, source_params=params)
    return super unless blacklight_config.facet_fields[field].multiple

    p = super
    # need to dup the facet values too,
    # if the values aren't dup'd, then the values
    # from the session will get remove in the show view...
    p[:f_inclusive] = (p[:f_inclusive] || {}).dup
    p[:f_inclusive][field] = (p[:f_inclusive][field] || []).dup
    p[:f_inclusive][field] = p[:f_inclusive][field] - [value]
    p[:f_inclusive].delete(field) if p[:f_inclusive][field].size == 0
    p
  end

  
  # override to use redirect, TODO: move these two methods into blacklight core.
  def render_selected_facet_value(facet_solr_field, item)
    content_tag(:span, render_facet_value(facet_solr_field, item, :suppress_link => true), :class => "selected label") +
      link_to(t('blacklight.search.facets.selected.remove'), remove_facet_params_and_redirect(facet_solr_field, item.value), :class=>"remove")
  end

  # Used in catalog/facet action, facets.rb view, for a click
  # on a facet value. Add on the facet params to existing
  # search constraints. Remove any paginator-specific request
  # params, or other request params that should be removed
  # for a 'fresh' display. 
  # Change the action to 'index' to send them back to
  # catalog/index with their new facet choice. 
  def remove_facet_params_and_redirect(field, value)
    new_params = remove_facet_params(field, value)

    # Delete page, if needed. 
    new_params.delete(:page)

    # Delete any request params from facet-specific action, needed
    # to redir to index action properly. 
    Blacklight::Solr::FacetPaginator.request_keys.values.each do |paginator_key| 
      new_params.delete(paginator_key)
    end
    new_params.delete(:id)

    # Force action to be index. 
    new_params[:action] = "index"
    new_params    
  end

  # true or false, depending on whether the field and value is in params[:f]
  def facet_in_params?(field, value)
    super || (params[:f_inclusive] and params[:f_inclusive][field] and params[:f_inclusive][field].include?(value))
  end
end
