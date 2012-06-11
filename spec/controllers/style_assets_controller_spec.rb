require 'spec_helper'

describe StyleAssetsController do
  render_views

  before :each do
    RSpec::Matchers.define :have_style_tag do |tag_name|
      match do |body|
        body =~ Regexp.new("<link.*href=\"#{tag_name}\".*>")
      end
    end
  end

  after :each do
    response.should be_success
  end

  describe 'supported style languages' do
    it 'CSS assets' do
      get :css
      response.body.should have_style_tag '/assets/style_assets/css/css.css'
    end

    it 'SASS assets' do
      get :sass
      response.body.should have_style_tag '/assets/style_assets/sass/sass.css'
    end

    it 'CSS.SASS assets' do
      get :css_sass
      response.body.should have_style_tag '/assets/style_assets/css_sass/css_sass.css'
    end

    it 'SCSS assets' do
      get :scss
      response.body.should have_style_tag '/assets/style_assets/scss/scss.css'
    end

    it 'CSS.SCSS assets' do
      get :css_scss
      response.body.should have_style_tag '/assets/style_assets/css_scss/css_scss.css'
    end
  end

  context 'setting a custom style filename' do
    before :each do
      get :custom_style
    end

    it 'includes the given style file into the page' do
      response.body.should have_style_tag '/assets/style_assets/custom_style/different_name.css'
    end

    it "doesn't include the default script file into the page" do
      response.body.should_not have_style_tag '/assets/style_assets/custom_style/custom_style.css'
    end
  end

  context 'setting the script configuration option to false' do
    it "doesn't include any script tag into the page" do
      get :no_style
      response.body.should_not have_style_tag '/assets/style_assets/no_style/no_style.css'
    end
  end
end

