module BlacklightFacetExtras::ControllerOverride
  def self.included(some_class)
    some_class.helper_method :blacklight_facet_config
  end
    def blacklight_facet_config(solr_field)
      {}
    end
end
