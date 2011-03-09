
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject pivot limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Pivot::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :facet_pivot_config
  end
  def solr_search_params(extra_params)
    solr_params = super(extra_params)

    blacklight_pivot_config.each do |k, config|
      solr_params[:"facet.field"].select { |x| x == k }.each do |x|
        solr_params[:"facet.field"].delete x
      end if solr_params[:"facet.field"]

      solr_params[:"facet.pivot"] ||= []
      solr_params[:"facet.pivot"] << config.join(",")
    end

    solr_params
  end

    def facet_pivot_config(solr_field)
      config = blacklight_pivot_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_pivot_config
      Blacklight.config[:facet][:pivot] || {}
    end
end
