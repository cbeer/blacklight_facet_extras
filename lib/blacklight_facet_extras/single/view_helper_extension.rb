module BlacklightFacetExtras::Single::ViewHelperExtension
  # adds the value and/or field to params[:f]
  # Does NOT remove request keys and otherwise ensure that the hash
  # is suitable for a redirect. See
  # add_facet_params_and_redirect
  def add_facet_params(field, value)
    return super unless blacklight_config.facet_fields[field].single

    p = params.dup
    p[:f] = (p[:f] || {}).dup # the command above is not deep in rails3, !@#$!@#$
    p[:f][field] = [value]
    p
  end

end
