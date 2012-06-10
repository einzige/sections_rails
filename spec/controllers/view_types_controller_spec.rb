require 'spec_helper'

describe ViewTypesController do
  render_views

  describe 'supported view types' do

    it 'allows to use the section helper in ERB views' do
      get :erb
      response.should be_success
      response.body.strip.should == 'ERB partial content'
    end

    it 'allows to use the section helper in HAML views' do
      get :haml
      response.should be_success
      response.body.strip.should == 'ERB partial content'
    end
  end
end

