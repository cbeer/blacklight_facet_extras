module BlacklightFacetExtras::Range
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
