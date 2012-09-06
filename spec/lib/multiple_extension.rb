require 'spec_helper'
describe "Multiple extensions" do
  describe BlacklightFacetExtras::Multiple::ControllerExtension do
    before do
      class MockController < ActionView::TestCase::TestController
        include Blacklight::Catalog
        include BlacklightFacetExtras::Multiple::ControllerExtension
      end
    end
    subject { MockController.new }
    it "should set fq" do
      solr_params = {}
      user_params = {:f_inclusive => {'state' => ['California']}}
      subject.add_inclusive_facets_to_solr(solr_params, user_params)
      solr_params[:fq].should == ["{!tag=state}_query_:\"{!raw f=state}California\""] 
    end

  end

  describe BlacklightFacetExtras::Multiple::ViewHelperExtension do

  end
end
