module BlacklightFacetExtras::ControllerExtension
  def self.included(some_class)
    some_class.helper_method :blacklight_facet_config
    some_class.helper BlacklightFacetExtras::ViewHelperExtension
  end
    def blacklight_facet_config(solr_field)
      {}
    end
end
