module BlacklightFacetExtras::Range
  class FacetItem <  RSolr::Ext::Response::Facets::FacetItem
    attr_accessor :display_label
    attr_accessor :from, :to

    def initialize value, hits, opts = {}
      super(value, hits)
      @display_label = value
      @from = opts[:from]
      @to = opts[:to]
    end

    def value
      return"[#{self.from} TO #{self.to}]" if self.from and self.to
      super
    end
  end

end
