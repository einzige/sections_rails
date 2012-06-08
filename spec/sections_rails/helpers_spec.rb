require 'spec_helper'
include SectionsRails::Helpers

describe SectionsRails::Helpers do

  describe '#split_path' do
    it 'returns the directory and filename of the given path' do
      directory, filename = split_path '/one/two/three.js'
      directory.should == '/one/two'
      filename.should == 'three.js'
    end

    it "returns '' if there is no directory" do
      directory, filename = split_path 'three.js'
      directory.should == ''
      filename.should == 'three.js'
    end
  end
end
