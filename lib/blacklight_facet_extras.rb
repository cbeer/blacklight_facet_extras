# BlacklightFacetExtras

module BlacklightFacetExtras
  @omit_inject = {}
  def self.omit_inject=(value)
    value = Hash.new(true) if value == true
    @omit_inject = value      
  end
  def self.omit_inject ; @omit_inject ; end
  
  def self.inject!
      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::ControllerOverride)
      end
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::ViewHelperOverride
         )
      end

      if Blacklight.config[:facet][:rangex]
      
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Range::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Range::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Range::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Range::ControllerOverride)
      end
      
      end

      if Blacklight.config[:facet][:tag]
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Tag::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Tag::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Tag::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Tag::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:query]
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Query::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Query::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Query::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Query::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:pivot]
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Pivot::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Pivot::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Pivot::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Pivot::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:filter]
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Filter::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Filter::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Filter::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Filter::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:hierarchy]
      unless omit_inject[:view_helpers]
        CatalogController.helper(
          BlacklightFacetExtras::Hierarchy::ViewHelperOverride
        ) unless
         CatalogController._helpers.include?( 
            BlacklightFacetExtras::Hierarchy::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Hierarchy::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Hierarchy::ControllerOverride)
      end

      end
  end

  # Add element to array only if it's not already there
  def self.safe_arr_add(array, element)
    array << element unless array.include?(element)
  end
  
end
