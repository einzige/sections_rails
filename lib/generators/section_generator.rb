# Generates a new section.
class SectionGenerator < Rails::Generators::Base
  include SectionsRails::Helpers

  argument :name, :type => :string

  def parse_arguments
    @section = SectionsRails::Section.new name
  end

  def create_folder
    empty_directory @section.folder_filepath
  end

  def create_partial
    create_file "#{@section.partial_filepath}.html.haml",
                ".#{@section.filename}\n  -# DOM content goes here.\n"
  end

  def create_coffee_file
    create_file "#{@section.asset_filepath}.coffee",
                "class #{@section.filename}\n  # Your CoffeeScript code goes here.\n"
  end

  def create_sass_file
    create_file "#{@section.asset_filepath}.sass",
                ".#{@section.filename}\n  /* Your SASS goes here. */\n"
  end
end
