require 'spec_helper'
describe "Multiple extensions" do
  describe BlacklightFacetExtras::Multiple::ControllerExtension do
    before :all do
      class MockController < ActionView::TestCase::TestController
        include Blacklight::Catalog
        include BlacklightFacetExtras::Multiple::ControllerExtension
        configure_blacklight do |config|
          config.default_solr_params = { } 
          config.add_facet_field 'format_facet', label: 'Format', limit: 20, multiple: true
          config.default_solr_params[:'facet.field'] = config.facet_fields.keys
          
        end
        
      end
    end
    subject { MockController.new }
    it "should set fq" do
      solr_params = {}
      user_params = {:f_inclusive => {'state' => ['California']}}
      subject.add_inclusive_facets_to_solr(solr_params, user_params)
      solr_params[:fq].should == ["{!tag=state}_query_:\"{!raw f=state}California\""] 
    end

    describe "add_inclusive_facets_to_solr" do
      it "should set :fq for f_inclusive facets" do
        solr_params = {:"facet.field"=>["format_facet"]}
        user_params = {'f_inclusive'=>{'format_facet'=>['Book']}}.with_indifferent_access
        subject.add_inclusive_facets_to_solr(solr_params, user_params)
        solr_params[:fq].should == ["{!tag=format_facet}_query_:\"{!raw f=format_facet}Book\""] 
      end
    end
    describe "add_multiple_facets_to_solr" do
      it "should set :fq for f_inclusive facets" do
        solr_params = {:"facet.field"=>["format_facet"]}
        user_params = {'f_inclusive'=>{'format_facet'=>['Book']}}.with_indifferent_access
        subject.add_multiple_facets_to_solr(solr_params, user_params)
        solr_params[:"facet.field"].should == ["{!ex=format_facet}format_facet"]
      end
    end

    describe "solr_facet_params" do
      it "should remove the f_inclusive filter for facet pagination (e.g. the 'more' facets page)" do
        # Used when hitting: /catalog/facet/format_facet?f_inclusive%format_facet%5D%5B%5D=Book
        user_params = extra_controller_params = {'f_inclusive'=>{'format_facet'=>['Book']}}.with_indifferent_access
        result = subject.solr_facet_params('format_facet', user_params, extra_controller_params)
        result[:fq].should be_nil
      end
    end

  end

  describe BlacklightFacetExtras::Multiple::ViewHelperExtension do
    before :all do
      class Helper
        include ActionView::Helpers::UrlHelper # provides link_to_unless
        include Blacklight::FacetsHelperBehavior
        include BlacklightFacetExtras::Multiple::ViewHelperExtension
        def blacklight_config
          @config ||= Blacklight::Configuration.new do |config|
            config.add_facet_field 'facet_field_1', :multiple=>true
            config.add_facet_field 'facet_field_2', :multiple=>true
          end
        end

      end
    end
    subject do
      Helper.new
    end

    describe "render_selected_facet_value" do
      before do
        catalog_facet_params = {:q => "query", 
                  :search_field => "search_field", 
                  :per_page => "50",
                  :page => "5",
                  :f_inclusive => {"facet_field_1" => ["value1"], "facet_field_2" => ["value2", "value2a"]},
                  Blacklight::Solr::FacetPaginator.request_keys[:offset] => "100",
                  Blacklight::Solr::FacetPaginator.request_keys[:sort] => "index",
                  :id => 'facet_field_name'
        }
        subject.stub!(:params).and_return(catalog_facet_params)
      end
      it "should draw a link that goes to the index action" do
        item = stub('facet_item', value: 'value2a', hits: 7)
        subject.should_receive(:t).with('blacklight.search.facets.selected.remove').and_return('remove')
        subject.should_receive(:t).with('blacklight.search.facets.count', {:number=>7}).and_return('(7)')
        subject.should_receive(:link_to).with('remove', {:q=>"query", :search_field=>"search_field", :per_page=>"50", :f_inclusive=>{"facet_field_1"=>["value1"], "facet_field_2"=>["value2"]}, :f=>{}, :action=>"index"}, {:class=>'remove'}).and_return("RemoveLink")
        subject.render_selected_facet_value('facet_field_2', item).should =="<span class=\"selected label\">value2a <span class=\"count\">(7)</span></span>RemoveLink"
      end
    end

    describe "remove_facet_params_and_redirect" do
      before do
        catalog_facet_params = {:q => "query", 
                  :search_field => "search_field", 
                  :per_page => "50",
                  :page => "5",
                  :f_inclusive => {"facet_field_1" => ["value1"], "facet_field_2" => ["value2", "value2a"]},
                  Blacklight::Solr::FacetPaginator.request_keys[:offset] => "100",
                  Blacklight::Solr::FacetPaginator.request_keys[:sort] => "index",
                  :id => 'facet_field_name'
        }
        subject.stub!(:params).and_return(catalog_facet_params)
      end
      it "should redirect to 'index' action" do
        params = subject.remove_facet_params_and_redirect("facet_field_2", "facet_value")

        params[:action].should == "index"
      end
      it "should not include request parameters used by the facet paginator" do
        params = subject.remove_facet_params_and_redirect("facet_field_2", "facet_value")

        bad_keys = Blacklight::Solr::FacetPaginator.request_keys.values + [:id]
        bad_keys.each do |paginator_key|
          params.keys.should_not include(paginator_key)        
        end
      end
      it 'should remove :page request key' do
        params = subject.remove_facet_params_and_redirect("facet_field_2", "facet_value")

        params.keys.should_not include(:page)
      end
      it "should otherwise do the same thing as add_facet_params" do
        removed_facet_params = subject.remove_facet_params("facet_field_2", "facet_value")
        removed_facet_params_from_facet_action = subject.remove_facet_params_and_redirect("facet_field_2", "facet_value")

        removed_facet_params_from_facet_action.each_pair do |key, value|
          next if key == :action
          value.should == removed_facet_params[key]
        end      
      end
    end

    

  end
end
