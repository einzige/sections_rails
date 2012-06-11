require 'spec_helper'

describe ScriptAssetsController do
  render_views

  before :each do
    RSpec::Matchers.define :have_script_tag do |tag_name|
      match do |body|
        body =~ Regexp.new("<script.*src=\"#{tag_name}\".*<\/script>")
      end
    end
  end

  after :each do
    response.should be_success
  end

  describe 'supported script languages' do
    it 'allows to use JavaScript assets' do
      get :javascript
      response.body.should have_script_tag '/assets/script_assets/javascript/javascript.js'
    end

    it 'allows to use CoffeeScript assets' do
      get :coffeescript
      response.body.should have_script_tag '/assets/script_assets/coffeescript/coffeescript.js'
    end
  end

  context 'setting a custom script filename' do
    before :each do
      get :custom_script
    end

    it 'includes the given script file into the page' do
      response.body.should have_script_tag '/assets/script_assets/custom_script/different_name.js'
    end

    it "doesn't include the default script file into the page" do
      response.body.should_not have_script_tag '/assets/script_assets/custom_script/custom_script.js'
    end
  end

  context 'setting the script configuration option to false' do
    it "doesn't include any script tag into the page" do
      get :no_script
      response.body.should_not match /<script/
    end
  end

  context 'production mode' do
    before :each do
      Rails.env = 'production'
    end

    after :each do
      Rails.env = 'test'
    end

    it "doesn't render script assets" do
      get :production_mode
      response.should_not have_script_tag '/assets/script_assets/production_mode/production_mode.js'
    end
  end
end



