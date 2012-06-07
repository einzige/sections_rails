require "spec_helper"

# TODO(SZ): missing specs.
describe SectionsRails::Section do
  before(:each) { Rails.stub(:root).and_return('/rails_root/') }
  subject { SectionsRails::Section.new 'folder/filename.ext' }

  describe 'initialize' do
    its(:filename)       { should == 'filename' }
    its(:directory_name) { should == 'folder' }
    its(:path)           { should == 'folder/filename' }
    its(:asset_path)     { should == 'folder/filename/filename' }
    its(:absolute_path)  { should == '/rails_root/app/sections/folder/filename' }
    its(:partial_path)   { should == 'folder/_filename' }
  end

  describe "#has_asset?" do

    it "tries filename variations with all given extensions" do
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.one").and_return(false)
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.two").and_return(false)

      subject.has_asset? ['one', 'two']
    end

    it "returns false if the files don't exist" do
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.one").and_return(false)
      subject.has_asset?(['one']).should be_false
    end

    it "returns true if one of the given extensions matches a file" do
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.one").and_return(false)
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.two").and_return(true)
      subject.has_asset?(['one', 'two']).should be_true
    end
  end

  describe "#has_default_js_asset" do
    it 'looks for all different types of JS file types' do
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.js").and_return(false)
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.coffee").and_return(false)
      File.should_receive(:exists?).with("/rails_root/app/sections/folder/filename.js.coffee").and_return(false)
      subject.has_default_js_asset?.should be_false
    end

    it 'returns TRUE if it JS file types' do
      File.stub!(:exists?).and_return(true)
      subject.has_default_js_asset?.should be_true
    end
  end
end
