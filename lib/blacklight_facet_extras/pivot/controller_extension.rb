
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject pivot limiting behaviors
# to solr parameters creation. 
module BlacklightFacetExtras::Pivot::ControllerExtension
  def self.included(some_class)
    some_class.send :include,BlacklightFacetExtras::ControllerExtension
    some_class.solr_search_params_logic << :add_pivot_facets_to_solr unless some_class.solr_search_params_logic.include? :add_pivot_facets_to_solr
    some_class.helper BlacklightFacetExtras::Pivot::ViewHelperExtension
  end

  def add_pivot_facets_to_solr(solr_parameters, user_parameters)
    blacklight_config.facet_fields.select { |key, config| config.pivot }.each do |key, config|
      solr_parameters[:"facet.field"].select { |x| x == key }.each do |x|
        solr_parameters[:"facet.field"].delete x
      end if solr_parameters[:"facet.field"]

      solr_parameters[:"facet.pivot"] ||= []
      solr_parameters[:"facet.pivot"] << config.pivot.join(",")
    end

    solr_parameters
  end

  module ::RSolr::Ext::Response::Facets
    def pivot_facets #_with_pivot
      @facets_with_pivot ||= (
        (facet_counts['facet_pivot'] || []).map do |(facet_pivot_name, values_and_hits)|
          field = pivot_field_from_facet_field(values_and_hits)
          PivotFacetField.new facet_pivot_name, field
        end
      )
    end

    def pivot_field_from_facet_field facet_field, parent_item = nil
      items = []
      field = FacetField.new facet_field.first['field'], items
      field.parent = parent_item if parent_item

      facet_field.each do |item|
        i = FacetItem.new(item['value'], item['count']) 

        if item['pivot']
          i.pivot = pivot_field_from_facet_field(item['pivot'], i)
        end

        i.field = field

        items << i
      end

      field
    end

    class PivotFacetField
      attr_reader :name
      attr_reader :root
      delegate :items, :to => :root

      def initialize name,root 
        @name = name
        @root = root 
      end
    end

    class FacetField
      attr_accessor :parent
    end

    class FacetItem
      attr_accessor :field
      attr_accessor :pivot
    end
  end
end
