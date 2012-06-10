require 'spec_helper'

describe ViewTypesController do
  render_views

  describe 'supported view types' do
    after :each do
      response.should be_success
    end

    it 'allows to use the section helper in ERB views' do
      get :erb
      response.body.strip.should == 'Foo partial content'
    end

    it 'allows to use the section helper in HAML views' do
      get :haml
      response.body.strip.should == 'Foo partial content'
    end
  end
end

