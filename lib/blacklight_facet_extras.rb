# BlacklightFacetExtras

module BlacklightFacetExtras
  @omit_inject = {}
  def self.omit_inject=(value)
    value = Hash.new(true) if value == true
    @omit_inject = value      
  end
  def self.omit_inject ; @omit_inject ; end
  
  def self.inject!
    Dispatcher.to_prepare do
      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::ControllerOverride)
      end

      if Blacklight.config[:facet][:rangex]
      
      unless omit_inject[:view_helpers]
        CatalogController.add_template_helper(
          BlacklightFacetExtras::Range::ViewHelperOverride
        ) unless
         CatalogController.master_helper_module.include?( 
            BlacklightFacetExtras::Range::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Range::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Range::ControllerOverride)
      end
      
      end

      if Blacklight.config[:facet][:tag]
      unless omit_inject[:view_helpers]
        CatalogController.add_template_helper(
          BlacklightFacetExtras::Tag::ViewHelperOverride
        ) unless
         CatalogController.master_helper_module.include?( 
            BlacklightFacetExtras::Tag::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Tag::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Tag::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:query]
      unless omit_inject[:view_helpers]
        CatalogController.add_template_helper(
          BlacklightFacetExtras::Query::ViewHelperOverride
        ) unless
         CatalogController.master_helper_module.include?( 
            BlacklightFacetExtras::Query::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Query::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Query::ControllerOverride)
      end

      end

      if Blacklight.config[:facet][:pivot]
      unless omit_inject[:view_helpers]
        CatalogController.add_template_helper(
          BlacklightFacetExtras::Pivot::ViewHelperOverride
        ) unless
         CatalogController.master_helper_module.include?( 
            BlacklightFacetExtras::Pivot::ViewHelperOverride
         )
      end

      unless omit_inject[:controller_mixin]
        CatalogController.send(:include, BlacklightFacetExtras::Pivot::ControllerOverride) unless CatalogController.include?(BlacklightFacetExtras::Pivot::ControllerOverride)
      end

      end

      CatalogController.before_filter do |controller|
        
        unless omit_inject[:css]
          safe_arr_add(controller.stylesheet_links ,
            ["blacklight_facet_extras", {:plugin => "blacklight_facet_extras"}])
        end

        unless omit_inject[:js]
          safe_arr_add(controller.javascript_includes,
                  ["facet_extras_slider", {:plugin => "blacklight_facet_extras"}])
        end
      
      end  
    end
  end

  # Add element to array only if it's not already there
  def self.safe_arr_add(array, element)
    array << element unless array.include?(element)
  end
  
end
