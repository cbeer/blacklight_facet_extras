module BlacklightFacetExtras::Pivot
    autoload :ControllerExtension, 'blacklight_facet_extras/pivot/controller_extension'
    autoload :ViewHelperExtension, 'blacklight_facet_extras/pivot/view_helper_extension'
  class FacetItem <  RSolr::Ext::Response::Facets::FacetItem
    attr_accessor :display_label
    attr_accessor :facets
    attr_accessor :field
    attr_accessor :parent

    def initialize value, hits, opts = {}
      super(value, hits)
      @display_label = opts[:display_label]
      @field = opts[:field]
      @parent = opts[:parent]
      @facets = opts[:facets]
    end
  end

end
