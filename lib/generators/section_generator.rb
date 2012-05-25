# Generates a new section.
class SectionGenerator < Rails::Generators::Base

  argument :name, :type => :string

  def create_folder
    empty_directory "app/sections/#{name}"
  end

  def create_partial
    create_file "app/sections/_#{name}.html.haml", 
                ".#{name}\n  -# DOM content goes here.\n"
  end

  def create_coffee_file
    create_file "app/sections/#{name}.coffee", 
                "# Your CoffeeScript code goes here.\n"
  end

  def create_sass_file
    create_file "app/sections/#{name}.sass",
                ".#{name}\n  /* Your SASS goes here. */\n"
  end
end
