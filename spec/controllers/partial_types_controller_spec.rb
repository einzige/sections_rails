require 'spec_helper'

describe PartialTypesController do
  render_views

  describe 'supported partial types' do

    it 'allows to use ERB partials' do
      get :erb
      response.should be_success
      response.body.strip.should == 'ERB partial content'
    end

    it 'allows to use HAML partials' do
      get :haml
      response.should be_success
      response.body.strip.should == 'HAML partial content'
    end
  end
end


