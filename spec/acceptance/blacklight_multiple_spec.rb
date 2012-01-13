require 'spec_helper'

describe 'Blacklight facet extras / multiple' do
  use_vcr_cassette "solr_multiple"
  before(:each) do
    CatalogController.send(:include, BlacklightFacetExtras::Multiple::ControllerExtension)
    CatalogController.blacklight_config = Blacklight::Configuration.new
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }

      config.add_facet_field 'facet', :multiple => true

      config.default_solr_params[:'facet.field'] = config.facet_fields.keys
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
    page.should have_content("label2 (3)")
  end

  it "facet 2 click" do
    visit '/'
    click_on "label"
    click_on "label2"
    page.should have_content("label (5)[remove]")
    page.should have_content("label2 (3)[remove]")
  end
end
