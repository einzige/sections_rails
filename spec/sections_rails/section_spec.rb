require "spec_helper"

describe SectionsRails::Section do
  before(:each) { Rails.stub(:root).and_return('/rails_root/') }
  subject { SectionsRails::Section.new 'folder/section', nil }

  describe 'initialize' do

    context 'with section in folder' do
      its(:filename)            { should == 'section' }
      its(:directory_name)      { should == 'folder' }
    end

    context 'without folder' do
      subject { SectionsRails::Section.new 'section', nil }
      its(:filename)            { should == 'section' }
      its(:directory_name)      { should == '' }
    end
  end

  describe 'path helper methods' do

    context 'section in a folder' do
      its(:folder_filepath) { should == 'app/sections/folder/section' }
      its(:asset_filepath)  { should == 'app/sections/folder/section/section' }
      its(:asset_includepath)  { should == 'folder/section/section' }
      its(:partial_filepath)  { should == 'app/sections/folder/section/_section' }
      it { subject.partial_filepath('foo').should == 'app/sections/folder/section/_foo' }
      its(:partial_includepath)  { should == 'folder/section/section' }
      its(:partial_renderpath)  { should == 'folder/section/section' }
      it { subject.partial_renderpath('foo').should == 'folder/section/foo' }
    end

    context 'section in root sections directory' do
      subject { SectionsRails::Section.new 'section' }
      its(:folder_filepath) { should == 'app/sections/section' }
      its(:asset_filepath)  { should == 'app/sections/section/section' }
      its(:asset_includepath)  { should == 'section/section' }
      its(:partial_filepath)  { should == 'app/sections/section/_section' }
      its(:partial_includepath)  { should == 'section/section' }
    end
  end

  describe 'find_js_includepath' do

    it 'tries all different JS asset file types for sections' do
      File.should_receive(:exists?).with("app/sections/folder/section/section.js").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.js.coffee").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.coffee").and_return(false)
      subject.find_js_includepath
    end

    it 'returns nil if there is no known JS asset file' do
      SectionsRails.config.js_extensions.each do |ext|
        File.should_receive(:exists?).with("app/sections/folder/section/section.#{ext}").and_return(false)
      end
      subject.find_js_includepath.should be_nil
    end

    it 'returns the asset path of the JS asset' do
      File.stub(:exists?).and_return(true)
      subject.find_js_includepath.should == 'folder/section/section'
    end

    it 'returns nil if the file exists but the section has JS assets disabled' do
      File.stub(:exists?).and_return(true)
      section = SectionsRails::Section.new 'folder/section', nil, js: false
      section.find_js_includepath.should be_nil
    end

    it 'returns the custom JS asset path if one is set' do
      File.stub(:exists?).and_return(true)
      section = SectionsRails::Section.new 'folder/section', nil, js: 'custom'
      section.find_js_includepath.should == 'custom'
    end
  end


  describe 'find_partial_renderpath' do

    it 'looks for all known types of partials' do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_renderpath
    end

    it "returns nil if it doesn't find any assets" do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_renderpath.should be_false
    end

    it "returns the path for rendering of the asset if it finds one" do
      File.stub(:exists?).and_return(true)
      subject.find_partial_renderpath.should == 'folder/section/section'
    end
  end


  describe 'find_partial_filepath' do

    it 'looks for all known types of partials' do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_filepath
    end

    it "returns nil if it doesn't find any assets" do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_filepath.should be_false
    end

    it "returns the absolute path to the asset if it finds one" do
      File.stub(:exists?).and_return(true)
      subject.find_partial_filepath.should == 'app/sections/folder/section/_section.html.erb'
    end
  end


  describe "#has_asset?" do

    it "tries filename variations with all given extensions" do
      File.should_receive(:exists?).with("app/sections/folder/section/section.one").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.two").and_return(false)
      subject.has_asset? ['one', 'two']
    end

    it "returns false if the files don't exist" do
      File.should_receive(:exists?).with("app/sections/folder/section/section.one").and_return(false)
      subject.has_asset?(['one']).should be_false
    end

    it "returns true if one of the given extensions matches a file" do
      File.should_receive(:exists?).with("app/sections/folder/section/section.one").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.two").and_return(true)
      subject.has_asset?(['one', 'two']).should be_true
    end
  end

  describe "#has_default_js_asset" do
    it 'looks for all different types of JS file types' do
      File.should_receive(:exists?).with("app/sections/folder/section/section.js").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.coffee").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/section.js.coffee").and_return(false)
      subject.has_default_js_asset?.should be_false
    end

    it 'returns TRUE if it JS file types' do
      File.stub!(:exists?).and_return(true)
      subject.has_default_js_asset?.should be_true
    end
  end

  describe 'partial_content' do
    it 'returns the content of the partial if one exists' do
      SectionsRails::Section.new('partial_content/erb_partial').partial_content.strip.should == 'ERB partial content'
      SectionsRails::Section.new('partial_content/haml_partial').partial_content.strip.should == 'HAML partial content'
    end

    it 'returns nil if no partial exists' do
      SectionsRails::Section.new('partial_content/no_partial').partial_content.should be_nil
    end
  end

  describe 'referenced_sections' do

    it 'returns the sections that are referenced in the section partial' do
      SectionsRails::Section.new('referenced_sections/erb_partial').referenced_sections.should == ['one', 'two/three']
      SectionsRails::Section.new('referenced_sections/haml_partial').referenced_sections.should == ['one', 'two/three']
    end

    it 'returns an empty array if there is no partial' do
      SectionsRails::Section.new('referenced_sections/no_partial').referenced_sections.should == []
    end

    it "returns an empty array if the partial doesn't reference any sections" do
      SectionsRails::Section.new('referenced_sections/no_referenced_sections').referenced_sections.should == []
    end

    it 'finds sections referenced by referenced sections' do
      SectionsRails::Section.new('referenced_sections/recursive').referenced_sections.should == ['referenced_sections/recursive/one', 'referenced_sections/recursive/three', 'referenced_sections/recursive/two']
    end

    it 'can handle reference loops' do
      SectionsRails::Section.new('referenced_sections/loop').referenced_sections.should == ['referenced_sections/loop', 'referenced_sections/loop/one']
    end
  end
end

