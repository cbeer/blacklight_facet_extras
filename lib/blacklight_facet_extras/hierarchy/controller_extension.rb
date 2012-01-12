# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject hierarchy limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Hierarchy::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_hierarchy_facets_to_solr unless some_class.solr_search_params_logic.include? :add_hierarchy_facets_to_solr
    some_class.helper BlacklightFacetExtras::Hierarchy::ViewHelperExtension
  end
  def facet_value_to_fq_string(facet_field, value)
    if blacklight_config.facet_fields[facet_field].hierarchy
      return "{!raw f=#{facet_field}}#{value.count("/") + 1}/#{value}"
    end

    super
  end
  def add_hierarchy_facets_to_solr(solr_parameters, user_params)
    blacklight_config.facet_fields.select { |key, config| config.hierarchy }.each do |key, config|
      f_request_params = user_params[:f] || {}
      value_list = f_request_params[key] || []

      if value_list.blank?
        solr_parameters[:"f.#{key}.facet.prefix"] ||= "1/"
      else
        value_list = [value_list] unless value_list.respond_to? :each

        value_list.each do |value|
          solr_parameters[:"f.#{key}.facet.prefix"] ||= "#{value.count("/") + 2}/#{value}/"
        end
      end
    end
  end
end
