require 'spec_helper'

describe ErrorsController do
  render_views

  context "referenced section doesn't exist" do
    it 'throws an exception' do
      expect { get :missing_section; puts response.body }.to raise_error
    end
  end

end



