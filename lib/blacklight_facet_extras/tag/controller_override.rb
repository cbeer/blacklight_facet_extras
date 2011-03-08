
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject tag limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Tag::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :facet_tag_config
  end
  def solr_search_params(extra_params)
    solr_params = super(extra_params)


    blacklight_tag_config.each do |k, config|


      values = []
      solr_params[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") }.each do |x|
        values << solr_params[:fq].delete(x)
      end if solr_params[:fq]

      solr_params[:fq] << "{!tag=#{config[:ex]}} #{values.map { |x| "_query_:\"#{x}\""}.join(" OR ") }"if solr_params[:fq]

      solr_params[:"facet.field"].each_with_index.select { |value, index| value == k }.each do |value, index|
        solr_params[:"facet.field"][index] = "{!ex=#{config[:ex]}}#{value}"
      end if solr_params[:"facet.field"]
    end

    solr_params
  end

    def facet_tag_config(solr_field)
      config = blacklight_tag_config[solr_field] || false
      config = {} if config == true
      config
    end

    def blacklight_tag_config
      Blacklight.config[:facet][:tag] || {}
    end
end
