require "spec_helper"

describe SectionsRails::PartialParser do

  describe '#find_sections' do
    it 'finds ERB sections with symbols' do
      SectionsRails::PartialParser.find_sections("one <%= section :alpha %> two").should == ['alpha']
    end

    it 'finds ERB sections with single quotes' do
      SectionsRails::PartialParser.find_sections("one <%= section 'alpha' %> two").should == ['alpha']
    end

    it 'finds ERB sections with double quotes' do
      SectionsRails::PartialParser.find_sections('one <%= section "alpha" %> two').should == ['alpha']
    end

    it 'finds ERB sections with parameters' do
      SectionsRails::PartialParser.find_sections('one <%= section "alpha", css: false %> two').should == ['alpha']
    end

    it 'finds HAML sections with symbols' do
      SectionsRails::PartialParser.find_sections("= section :alpha").should == ['alpha']
    end

    it 'finds HAML sections with single quotes' do
      SectionsRails::PartialParser.find_sections("= section 'alpha'").should == ['alpha']
    end

    it 'finds HAML sections with double quotes' do
      SectionsRails::PartialParser.find_sections('= section "alpha"').should == ['alpha']
    end

    it 'finds indented HAML sections' do
      SectionsRails::PartialParser.find_sections('    = section :alpha').should == ['alpha']
    end

    it 'finds HAML sections with parameters' do
      SectionsRails::PartialParser.find_sections('= section "alpha", css: false').should == ['alpha']
    end

    it 'finds all results in the text' do
      SectionsRails::PartialParser.find_sections("one <%= section 'alpha' \ntwo <%= section 'beta'").should == ['alpha', 'beta']
    end

    it 'sorts the results' do
      SectionsRails::PartialParser.find_sections("one <%= section 'beta' \ntwo <%= section 'alpha'").should == ['alpha', 'beta']
    end

    it 'removes duplicates' do
      SectionsRails::PartialParser.find_sections("one <%= section 'alpha' \ntwo <%= section 'alpha'").should == ['alpha']
    end
  end
end

