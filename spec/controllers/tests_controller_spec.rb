require 'spec_helper'

describe TestsController do
  render_views

  describe 'including partials' do
    it 'includes ERB partials' do
      get :erb_section
      response.should be_success
      response.body.strip.should == 'ERB partial content'
    end

    it 'includes HAML partials' do
      get :haml_section
      response.should be_success
      response.body.strip.should == 'HAML partial content'
    end
  end
end
