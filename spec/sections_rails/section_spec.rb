require "spec_helper"

# TODO(SZ): missing specs.
describe SectionsRails::Section do
  before(:each) { Rails.stub(:root).and_return('/rails/root/') }
  subject { SectionsRails::Section.new 'folder/filename.ext' }

  describe 'initialize' do
    its(:filename)     { should == 'filename' }
    its(:directory)    { should == 'folder' }
    its(:path)         { should == 'folder/filename' }
    its(:asset_path)   { should == 'folder/filename/filename' }
    its(:global_path)  { should == '/rails/root/app/sections/folder/filename' }
    its(:partial_path) { should == 'folder/_filename' }
  end

  describe "#has_asset?" do
    let(:extensions) { ['erb', 'haml'] }
    let(:ext) { 'erb' }

    before(:each) do
      File.should_receive(:exists?).with("#{subject.global_path}.#{ext}").and_return(file_exists)
    end

    context "file exists" do
      let(:file_exists) { true }

      it("returns true") { subject.has_asset?(ext).should be_true }

      context "for javascript assets" do
        let(:ext) { 'js' }
        its(:has_js_asset?) { should == true }
      end

      context "for stylesheet assets" do
        let(:ext) { 'css' }
        its(:has_style_asset?) { should == true }
      end
    end

    context "file does not exist" do
      let(:file_exists) { false }

      it("returns false") { subject.has_asset?(ext).should be_false }

      context "for javascript assets" do
        let(:ext) { 'js' }
        its(:has_js_asset?) { should == false }
      end

      context "for stylesheet assets" do
        let(:ext) { 'css' }
        its(:has_style_asset?) { should == false }
      end
    end
  end
end