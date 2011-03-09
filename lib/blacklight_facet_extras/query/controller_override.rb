
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject query limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Query::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :facet_query_config
  end
  def solr_search_params(extra_params)
    solr_params = super(extra_params)

    blacklight_query_config.each do |k, config|
      solr_params[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") }.each do |x|
        v = solr_params[:fq].delete x

        solr_params[:fq] << v.gsub("{!raw f=#{k}}", "")
      end if solr_params[:fq]

      solr_params[:"facet.field"].select { |x| x == k }.each do |x|
        solr_params[:"facet.field"].delete x
      end if solr_params[:"facet.field"]

      solr_params[:"facet.query"] ||= []
      config.each do |label, query|
        solr_params[:"facet.query"] << query
      end
    end

    solr_params
  end

    def facet_query_config(solr_field)
      config = blacklight_query_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_query_config
      Blacklight.config[:facet][:query] || {}
    end
end
