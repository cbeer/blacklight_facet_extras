# BlacklightFacetExtras

module BlacklightFacetExtras
  autoload :ControllerExtension, 'blacklight_facet_extras/controller_extension'
  autoload :ViewHelperExtension, 'blacklight_facet_extras/view_helper_extension'
  autoload :RouteSets, 'blacklight_facet_extras/route_sets'

  autoload :FacetItem, 'blacklight_facet_extras/facet_item'
  autoload :Filter, 'blacklight_facet_extras/filter'
  autoload :Hierarchy, 'blacklight_facet_extras/hierarchy'
  autoload :Pivot, 'blacklight_facet_extras/pivot'
  autoload :Range, 'blacklight_facet_extras/range'
  autoload :Query, 'blacklight_facet_extras/query'
  autoload :Tag, 'blacklight_facet_extras/tag'

  require 'blacklight_facet_extras/version'
  require 'blacklight_facet_extras/engine'

  @omit_inject = {}
  def self.omit_inject=(value)
    value = Hash.new(true) if value == true
    @omit_inject = value      
  end
  def self.omit_inject ; @omit_inject ; end
  
  def self.inject!
  end

  # Add element to array only if it's not already there
  def self.safe_arr_add(array, element)
    array << element unless array.include?(element)
  end
  
end
