module BlacklightFacetExtras::Range
    autoload :ControllerExtension, 'blacklight_facet_extras/range/controller_extension'
    autoload :ViewHelperExtension, 'blacklight_facet_extras/range/view_helper_extension'
  class FacetItem <  BlacklightFacetExtras::FacetItem
    attr_accessor :from, :to

    def initialize value, hits, opts = {}
      super(value, hits, opts = {})
      @from = opts[:from]
      @to = opts[:to]
    end

    def value
      return"[#{self.from} TO #{self.to}]" if self.from and self.to
      super
    end
  end

end
