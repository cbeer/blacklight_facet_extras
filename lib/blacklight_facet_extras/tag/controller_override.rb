
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject tag limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Tag::ControllerOverride
  def self.included(some_class)
    some_class.solr_search_params_logic << :add_tag_facets_to_solr
    some_class.helper_method :facet_tag_config
  end
  def add_tag_facets_to_solr(solr_parameters, user_parameters)
    blacklight_tag_config.each do |k, config|


      values = []
      if solr_parameters[:fq]
        solr_parameters[:fq].select { |x| x.starts_with?("{!raw f=#{k}}") }.each do |x|
          values << solr_parameters[:fq].delete(x)
        end 
        solr_parameters[:fq] << "{!tag=#{config[:ex]}} #{values.map { |x| "_query_:\"#{x}\""}.join(" OR ") }" unless values.empty?
      end

      solr_parameters[:"facet.field"].each_with_index.select { |value, index| value == k }.each do |value, index|
        solr_parameters[:"facet.field"][index] = "{!ex=#{config[:ex]}}#{value}"
      end if solr_parameters[:"facet.field"]
    end

    solr_parameters
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
