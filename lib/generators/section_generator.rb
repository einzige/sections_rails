# Generates a new section.
class SectionGenerator < Rails::Generators::Base
  include SectionsRails::Helpers

  argument :name, :type => :string

  def create_folder
    empty_directory directory_path
  end

  def create_partial
    filename = File.basename(name)
    create_file "_#{asset_base_path '_'}.html.haml",
                ".#{filename}\n  -# DOM content goes here.\n"
  end

  def create_coffee_file
    filename = File.basename(name)
    create_file "#{asset_base_path}.coffee",
                "class #{filename}\n  # Your CoffeeScript code goes here.\n"
  end

  def create_sass_file
    filename = File.basename(name)
    create_file "#{asset_base_path}.sass",
                ".#{filename}\n  /* Your SASS goes here. */\n"
  end

  private

  # Returns the path for the directory of the section.
  def directory_path
    @directory_path ||= begin
      directory, filename = split_path(name)
      "app/sections/#{directory}#{filename}"
    end
  end

  # Returns the base path of the file, i.e. '/app/sections/admin/foo/foo'.
  def asset_base_path file_prefix = nil
    filename = File.basename(name)
    "#{directory_path}/#{file_prefix}#{filename}"
  end
end
