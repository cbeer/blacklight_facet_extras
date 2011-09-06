
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject range limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Range::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_range_facets_to_solr
    some_class.helper_method :facet_range_config
    some_class.helper BlacklightFacetExtras::Range::ViewHelperExtension
  end
  def add_range_facets_to_solr(solr_parameters, user_parameters)
    solr_parameters['facet.range.other'] = 'all'
    blacklight_range_config.each do |k, config|
      solr_parameters['facet.range'] = k

      solr_parameters[:fq] ||= []
      fq = solr_parameters[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") and x =~ /\[.* TO .*\]/ }.map { |x| solr_parameters[:fq].delete(x) }.map { |x| x.gsub("{!raw f=#{k}}", "") }.map { |x| x.scan(/\[(.*) TO (.*)\]/).first }

      range_start = fq.map { |x| x.first }.max
      range_end = fq.map { |x| x.last }.min
      range_gap = ((range_end.to_i - range_start.to_i) / (facet_limit_for(k) || 10)) if range_start and range_end


      solr_parameters["f.#{k}.facet.range.start"] = range_start || config[:start]
      solr_parameters["f.#{k}.facet.range.end"] = range_end || config[:end]
      solr_parameters["f.#{k}.facet.range.gap"] = range_gap || config[:gap]
      solr_parameters["f.#{k}.facet.mincount"] = config[:mincount] if config[:mincount]

      solr_parameters[:fq] << "#{k}:[#{range_start} TO #{range_end}]" if range_start and range_end
    end
  end

    def facet_range_config(solr_field)
      config = blacklight_range_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_range_config
      Blacklight.config[:facet][:rangex] || {}
    end
end
