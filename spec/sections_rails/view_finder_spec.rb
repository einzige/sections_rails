require "spec_helper"
require 'sections_rails/view_finder'


describe "SectionsRails::ViewFinder" do

  describe '#find_all_views' do
    let(:result) { SectionsRails::ViewFinder.find_all_views 'spec/sections_rails/view_finder_spec' }
    let(:empty_result) { SectionsRails::ViewFinder.find_all_views 'spec/sections_rails/view_finder_spec/empty' }

    it 'returns all erb views' do
      result.should include 'spec/sections_rails/view_finder_spec/erb/_erb.html.erb'
    end

    it 'returns all haml views' do
      result.should include 'spec/sections_rails/view_finder_spec/haml/_haml.html.haml'
    end

    it 'returns views that are deeper nested in the directory structure' do
      result.should include 'spec/sections_rails/view_finder_spec/nested/deeper/nested.html.erb'
    end

    it 'returns an empty array if there are no views' do
      empty_result.should == []
    end
  end
end

