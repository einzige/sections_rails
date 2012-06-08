require "spec_helper"

# TODO(SZ): missing specs.
describe SectionsRails::Section do
  before(:each) { Rails.stub(:root).and_return('/rails_root/') }
  subject { SectionsRails::Section.new 'folder/section', nil }

  describe 'initialize' do

    context 'with section in folder' do
      its(:filename)            { should == 'section' }
      its(:directory_name)      { should == 'folder' }
      its(:asset_path)          { should == 'folder/section/section' }
      its(:absolute_asset_path) { should == 'app/sections/folder/section/section' }
      its(:partial_path)        { should == 'folder/section/_section' }
    end

    context 'without folder' do
      subject { SectionsRails::Section.new 'section', nil }
      its(:filename)            { should == 'section' }
      its(:directory_name)      { should == '' }
      its(:asset_path)          { should == 'section/section' }
      its(:absolute_asset_path) { should == 'app/sections/section/section' }
      its(:partial_path)        { should == 'section/_section' }
    end
  end

  describe 'find_js_asset_path' do
    it 'tries all different JS asset file types for sections' do
      SectionsRails.config.js_extensions.each do |ext|
        File.should_receive(:exists?).with("app/sections/folder/section/section.#{ext}").and_return(false)
      end
      subject.find_js_asset_path
    end

    it 'returns nil if there is no known JS asset file' do
      SectionsRails.config.js_extensions.each do |ext|
        File.should_receive(:exists?).with("app/sections/folder/section/section.#{ext}").and_return(false)
      end
      subject.find_js_asset_path.should be_false
    end

    it 'returns the asset path of the JS asset' do
      File.stub(:exists?).and_return(true)
      subject.find_js_asset_path.should == 'folder/section/section'
    end

    it 'returns nil if the file exists but the section has JS assets disabled' do
      File.stub(:exists?).and_return(true)
      section = SectionsRails::Section.new 'folder/section', nil, js: false
      section.find_js_asset_path.should be_false
    end

    it 'returns the custom JS asset path if one is set' do
      section = SectionsRails::Section.new 'folder/section', nil, js: 'custom'
      section.find_js_asset_path.should == 'custom'
    end
  end


  describe 'find_partial_filename' do

    it 'looks for all known types of partials' do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_filename
    end

    it "returns nil if it doesn't find any assets" do
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.erb").and_return(false)
      File.should_receive(:exists?).with("app/sections/folder/section/_section.html.haml").and_return(false)
      subject.find_partial_filename.should be_false
    end

    it "returns the absolute path to the asset if it finds one" do
      File.stub(:exists?).and_return(true)
      subject.find_partial_filename.should == 'app/sections/folder/section/_section.html.erb'
    end
  end


  describe '#find_sections' do
    it 'finds ERB sections with symbols' do
      SectionsRails::Section.find_sections("one <%= section :alpha %> two").should == ['alpha']
    end

    it 'finds ERB sections with single quotes' do
      SectionsRails::Section.find_sections("one <%= section 'alpha' %> two").should == ['alpha']
    end

    it 'finds ERB sections with double quotes' do
      SectionsRails::Section.find_sections('one <%= section "alpha" %> two').should == ['alpha']
    end

    it 'finds ERB sections with parameters' do
      SectionsRails::Section.find_sections('one <%= section "alpha", css: false %> two').should == ['alpha']
    end

    it 'finds HAML sections with symbols' do
      SectionsRails::Section.find_sections("= section :alpha").should == ['alpha']
    end

    it 'finds HAML sections with single quotes' do
      SectionsRails::Section.find_sections("= section 'alpha'").should == ['alpha']
    end

    it 'finds HAML sections with double quotes' do
      SectionsRails::Section.find_sections('= section "alpha"').should == ['alpha']
    end

    it 'finds indented HAML sections' do
      SectionsRails::Section.find_sections('    = section "alpha"').should == ['alpha']
    end

    it 'finds HAML sections with parameters' do
      SectionsRails::Section.find_sections('= section "alpha", css: false').should == ['alpha']
    end

    it 'finds all results in the text' do
      SectionsRails::Section.find_sections("one <%= section 'alpha' \ntwo <%= section 'beta'").should == ['alpha', 'beta']
    end

    it 'sorts the results' do
      SectionsRails::Section.find_sections("one <%= section 'beta' \ntwo <%= section 'alpha'").should == ['alpha', 'beta']
    end

    it 'removes duplicates' do
      SectionsRails::Section.find_sections("one <%= section 'alpha' \ntwo <%= section 'alpha'").should == ['alpha']
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
end
