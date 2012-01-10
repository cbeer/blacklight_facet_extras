require 'spec_helper'

describe 'Blacklight facet extras / hierarchy' do
  use_vcr_cassette "solr_hierarchy"
  before do
    CatalogController.send(:include, BlacklightFacetExtras::Hierarchy::ControllerExtension)
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }

      config.add_facet_field 'hierarchy_facet', :hierarchy => true
    end
  end

  it "level 1" do
    visit '/'
    page.should have_content("a (5)")
    page.should have_content("b (3)")
  end

  it "level 2" do
    visit '/'
    click_on 'a'
    page.should have_content("1 (2)")
    page.should have_content("2 (1)")
  end
end
