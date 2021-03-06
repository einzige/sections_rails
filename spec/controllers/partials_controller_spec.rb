require 'spec_helper'

describe PartialsController do
  render_views

  describe 'supported partial types' do
    after :each do
      response.should be_success
    end

    it 'allows to use ERB partials' do
      get :erb_section
      response.body.strip.should == 'ERB partial content'
    end

    it 'allows to use HAML partials' do
      get :haml_section
      response.body.strip.should == 'HAML partial content'
    end
  end

  context 'no partial options given' do
    it 'renders the default partial' do
      get :no_options
      response.body.strip.should == 'default partial content'
    end
  end

  describe 'providing a custom partial name' do
    before :each do
      get :custom_partial
    end

    it 'renders the given partial' do
      response.body.should include 'custom partial content'
    end

    it "doesn't render the default partial" do
      response.body.should_not include 'default partial content'
    end
  end

  describe 'disabling partials for a section' do
    before :each do
      get :disabled
    end

    it "doesn't render the partial tag" do
      response.body.strip.should_not include '<div class="disabled">'
    end

    it "doesn't render the partial" do
      response.body.strip.should_not include 'disabled partial content'
    end
  end

  describe 'production mode' do

    before :each do
      Rails.env = 'production'
    end

    after :each do
      Rails.env = 'test'
    end

    it 'renders partials normally' do
      get :production_mode
      response.body.strip.should include 'partial content'
    end
  end

  describe 'partial with block' do
    it 'allows to render the block inside the partial' do
      get :partial_with_block
      response.body.strip.should == "partial line 1.\nblock content.\npartial line 2."
    end
  end
end


