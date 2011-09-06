# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject hierarchy limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Hierarchy::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.helper_method :facet_hierarchy_config
    some_class.helper_method :blacklight_hierarchy_config
    some_class.solr_search_params_logic << :add_hierarchy_facets_to_solr
    some_class.helper BlacklightFacetExtras::Hierarchy::ViewHelperExtension
  end
  def add_hierarchy_facets_to_solr(solr_parameters, user_parameters)
    blacklight_hierarchy_config.each do |k, config|

      fq = (solr_parameters[:fq] || []).select { |x| x.starts_with? "{!raw f=#{k}}" }.first.to_s

      value = fq.gsub("{!raw f=#{k}}", "")
      solr_parameters[:fq].delete(fq)

      if value.blank?
        solr_parameters[:"f.#{k}.facet.prefix"] ||= "1/" 
      else
        solr_parameters[:fq] << "{!raw f=#{k}}#{value.count("/") + 1}/#{value}"
        solr_parameters[:"f.#{k}.facet.prefix"] ||= "#{value.count("/") + 2}/#{value}/"
      end
    end

    solr_parameters
  end
    def facet_hierarchy_config(solr_field)
      config = blacklight_hierarchy_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_hierarchy_config
      Blacklight.config[:facet][:hierarchy] || {}
    end
end
