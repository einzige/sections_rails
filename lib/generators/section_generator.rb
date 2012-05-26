# Generates a new section.
class SectionGenerator < Rails::Generators::Base
  argument :name, :type => :string

  def create_folder
    empty_directory directory_path
  end

  def create_partial
    directory, filename = split_path
    create_file "#{asset_base_path '_'}.html.haml",
                ".#{filename}\n  -# DOM content goes here.\n"
  end

  def create_coffee_file
    directory, filename = split_path
    create_file "#{asset_base_path}.coffee",
                "class #{filename}\n  # Your CoffeeScript code goes here.\n"
  end

  def create_sass_file
    directory, filename = split_path
    create_file "#{asset_base_path}.sass",
                ".#{filename}\n  /* Your SASS goes here. */\n"
  end


  private

  # Returns an array [directory, filename] of the given filename.
  def split_path
    split_names = name.split '/'
    filename = split_names[-1]
    directory = split_names[0..-2].join '/'
    directory += '/' if directory.size > 0
    [directory, filename]
  end

  # Returns the path for the directory of the section.
  def directory_path
    directory, filename = split_path
    "app/sections/#{directory}#{filename}"
  end

  # Returns the base path of the file, i.e. '/app/sections/admin/foo/foo'.
  def asset_base_path file_prefix = nil
    directory, filename = split_path
    "#{directory_path}/#{file_prefix}#{filename}"
  end
end
