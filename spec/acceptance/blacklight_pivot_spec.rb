require 'spec_helper'

describe 'Blacklight facet extras / pivot' do
  describe "2-level pivot" do
  use_vcr_cassette "solr_pivot"
  before(:each) do
    CatalogController.send(:include, BlacklightFacetExtras::Pivot::ControllerExtension)
    CatalogController.blacklight_config = Blacklight::Configuration.new
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }

      config.add_facet_field 'first_facet,last_facet', :pivot => ['first_facet', 'last_facet']
    end
  end

  it "" do
    visit '/'
    page.should have_content("1 (5)")
    page.should have_content("a (3)")
  end

  it "" do
    visit '/'
    click_on "a"
    page.should have_content("1 (3)[remove]")
    page.should have_content("a (3)[remove]")
  end
  end   

  describe "3-level pivot" do
  use_vcr_cassette "solr_pivot"
  before(:each) do
    CatalogController.send(:include, BlacklightFacetExtras::Pivot::ControllerExtension)
    CatalogController.blacklight_config = Blacklight::Configuration.new
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }

      config.add_facet_field 'first_facet,middle_facet,last_facet', :pivot => ['first_facet','middle_facet','last_facet']
    end
  end

  it "" do
    visit '/'
    page.should have_content("1 (5)")
    page.should have_content("% (5)")
    page.should have_content("a (3)")
  end

  it "" do
    visit '/'
    click_on "a"
    page.should have_content("1 (3)[remove]")
    page.should have_content("% (3)[remove]")
    page.should have_content("a (3)[remove]")
  end
  end 
end
