require 'spec_helper'

describe 'Blacklight facet extras / query' do
  use_vcr_cassette "solr_query"
  before(:each) do
    CatalogController.send(:include, BlacklightFacetExtras::Query::ControllerExtension)
    CatalogController.blacklight_config = Blacklight::Configuration.new
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }

      config.add_facet_field 'my_query_field', :query => { 'label' => 'value:1', 'label2' => 'value:2'}
    end
  end

  it "initial" do
    visit '/'
    page.should have_content("label (5)")
    page.should have_content("label2 (3)")
  end

  it "facet click" do
    visit '/'
    click_on "label"
    page.should have_content("label (5)[remove]")
  end
end
