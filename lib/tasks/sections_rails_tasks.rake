namespace :sections do 

  desc "Prepares the assets for precompilation in a setup with a single application.js file"
  task :prepare do

    # Find all views in this app.
    views = find_all_views 'app/views'
    
    # Get all sections used in the views.
    sections = views.map do |view|
      find_sections_in_view IO.read "app/views/#{view}"
    end.flatten
    
    # Create the require file for application.js.
    File.open "app/assets/javascripts/application_sections.js", 'w' do |file|
      file.write "// THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN.\n"
      file.write "// PLEASE DO NOT MODIFY MANUALLY.\n"
      file.write "//\n"
      sections.each do |section|
        if File.exists? "app/sections/#{section}/#{section}.js"
          file.write "//= require ../../sections/#{section}/#{section} \n"
        end
      end
    end
    
    # Create the require file for application.css.
    File.open "app/assets/stylesheets/application_sections.css", 'w' do |file|
      file.write "/* \n"
      file.write " * THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN.\n"
      file.write " * PLEASE DO NOT MODIFY MANUALLY.\n"
      file.write " *\n"
      sections.each do |section|
        if File.exists? "app/sections/#{section}/#{section}.css"
          file.write " *= require ../../sections/#{section}/#{section}\n" 
        end
      end
      file.write "*/"
    end
    
    # Make sure the require files are properly linked.
    unless file_contains 'app/assets/javascripts/application.js', /application_sections/
      puts "Please add the 'require' statement to 'application_sections.js' to 'application.js'."
    end
    unless file_contains 'app/assets/stylesheets/application.css', /application_sections/
      puts "Please add the 'require' statement to 'application_sections.css' to 'application.css'."
    end
  end

  desc "Prepares the assets for precompilation in a setup with multiple files per page."
  task :prepare_pages do
    root = 'app/views'

    views = find_all_views root
    sections_per_view = parse_views views
    
    # Create the require files.
    sections_per_view.each do |view, sections|

      # Don't do anything if there are no sections in this view.
      next if sections.blank?
      
      # Don't do anything if the page has no page-specific JS file.
      root_name = view[0..-10]
      puts root_name
      next unless File.exists? "app/pages/#{view}.js"
    end
  end  

  # Returns an array with the file name of all views in the given directory.
  # Views are all files that end in .html.erb
  def find_all_views root
    result = []
    Dir.entries(root).each do |dir|
      next if ['.', '..', 'layouts'].include? dir      
      Dir.entries(File.join(root, dir)).each do |view_file|
        next if ['.', '..'].include? view_file
        result << File.join(dir, view_file)
      end
    end
    result
  end

  def parse_views views
    result = {}
    views_to_parse.each do |view_to_parse|
      view_text = IO.read(File.join root, view_to_parse)
      result[view_to_parse] = find_sections_in_view view_text
    end
    result
  end
  
  # Returns an array with the name of all sections in the given view source.
  def find_sections_in_view view_text
    view_text.scan(/<%= section\s+['"](.*?)['"]\s*%>/).flatten.sort.uniq
  end
  
  # Returns whether the given file contains the given text somewhere in its content.
  def file_contains file_name, text
    IO.read(file_name) =~ text
  end
  
end
