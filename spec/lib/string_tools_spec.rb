require 'spec_helper'
require 'sections_rails/string_tools'

describe 'string_tools' do

  describe 'find_sections' do
    it 'finds ERB sections with symbols' do
      find_sections("one <%= section :alpha %> two").should == ['alpha']
    end

    it 'finds ERB sections with single quotes' do
      find_sections("one <%= section 'alpha' %> two").should == ['alpha']
    end

    it 'finds ERB sections with double quotes' do
      find_sections('one <%= section "alpha" %> two').should == ['alpha']
    end

    it 'finds ERB sections with parameters' do
      find_sections('one <%= section "alpha", css: false %> two').should == ['alpha']
    end

    it 'finds HAML sections with symbols' do
      find_sections("= section :alpha").should == ['alpha']
    end

    it 'finds HAML sections with single quotes' do
      find_sections("= section 'alpha'").should == ['alpha']
    end

    it 'finds HAML sections with double quotes' do
      find_sections('= section "alpha"').should == ['alpha']
    end

    it 'finds indented HAML sections' do
      find_sections('    = section "alpha"').should == ['alpha']
    end

    it 'finds HAML sections with parameters' do
      find_sections('= section "alpha", css: false').should == ['alpha']
    end

    it 'finds all results in the text' do
      find_sections("one <%= section 'alpha' \ntwo <%= section 'beta'").should == ['alpha', 'beta']
    end

    it 'sorts the results' do
      find_sections("one <%= section 'beta' \ntwo <%= section 'alpha'").should == ['alpha', 'beta']
    end

    it 'removes duplicates' do
      find_sections("one <%= section 'alpha' \ntwo <%= section 'alpha'").should == ['alpha']
    end
  end

  describe 'split_path' do
    it 'returns the directory and filename of the given path' do
      directory, filename = split_path '/one/two/three.js'
      directory.should == '/one/two/'
      filename.should == 'three.js'
    end

    it "returns '' if there is no directory" do
      directory, filename = split_path 'three.js'
      directory.should == ''
      filename.should == 'three.js'
    end
  end
end
