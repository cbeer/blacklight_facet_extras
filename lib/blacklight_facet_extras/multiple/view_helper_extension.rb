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

  # true or false, depending on whether the field and value is in params[:f]
  def facet_in_params?(field, value)
    super || (params[:f_inclusive] and params[:f_inclusive][field] and params[:f_inclusive][field].include?(value))
  end
end
