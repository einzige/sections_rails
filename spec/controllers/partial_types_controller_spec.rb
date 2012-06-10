require 'spec_helper'

describe PartialTypesController do
  render_views

  describe 'supported partial types' do
    after :each do
      response.should be_success
    end

    it 'allows to use ERB partials' do
      get :erb
      response.body.strip.should == 'ERB partial content'
    end

    it 'allows to use HAML partials' do
      get :haml
      response.body.strip.should == 'HAML partial content'
    end
  end

  describe 'providing a custom partial name'

  describe 'disabling partials for a section'
end


