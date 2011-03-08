
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject range limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Range::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :facet_range_config
  end
  def solr_search_params(extra_params)
    solr_params = super(extra_params)



    solr_params['facet.range.other'] = 'all'
    blacklight_range_config.each do |k, config|
      solr_params['facet.range'] = k
      solr_params["f.#{k}.facet.range.start"] = config[:start]
      solr_params["f.#{k}.facet.range.end"] = config[:end]
      solr_params["f.#{k}.facet.range.gap"] = config[:gap]

      solr_params[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") }.each do |x|
        v = solr_params[:fq].delete x

        solr_params[:fq] << v.gsub("{!raw f=#{k}}", "#{k}:")
      end if solr_params[:fq]
    end

    solr_params
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
