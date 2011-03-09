module BlacklightFacetExtras::Query
  class FacetItem <  RSolr::Ext::Response::Facets::FacetItem
    attr_accessor :display_label

    def initialize value, hits, opts = {}
      super(value, hits)
      @display_label = opts[:display_label]
    end
  end

end
