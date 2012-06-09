require 'spec_helper'

describe TestsController do
  render_views

  describe 'one' do
    it 'works' do
      get :one
      response.should be_success
      response.body.strip.should == 'Hello!'
    end
  end
end
