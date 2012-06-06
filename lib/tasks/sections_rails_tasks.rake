namespace :sections do 

  desc "Prepares the assets for precompilation in a setup with a single application.js file"
  task :prepare do
    puts "\nPreparing sections assets ..."

    # Find all views in this app.
    views = find_all_views 'app/views'
    
    # Get all sections used in the views.
    sections = views.map do |view|
      find_sections_in_view IO.read "app/views/#{view}"
    end.flatten
    
    i = 0
    while i < sections.size
      section = sections[i]
      more_sections = find_sections_in_section section
      puts "Found these sections in #{section}: #{more_sections}"
      sections.concat more_sections
      sections.uniq!
      i += 1
    end
    
    # Create the require file for application.js.
    File.open "app/assets/javascripts/application_sections.js", 'w' do |file|
      sections.each do |section|

        if File.exists?(asset_path section, '.js') || File.exists?(asset_path section, '.js.coffee') || File.exists?(asset_path section, '.coffee')
          file.write "//= require #{require_path section}\n"
        end
      end
    end
    
    # Create the require file for application.css.
    File.open "app/assets/stylesheets/application_sections.css", 'w' do |file|
      file.write "/* \n"
      sections.each do |section|
        if File.exists?(asset_path section, '.css') || File.exists?(asset_path section, '.css.scss') || File.exists?(asset_path section, '.css.sass') || File.exists?(asset_path section, '.scss') || File.exists?(asset_path section, '.sass')
          file.write " *= require #{require_path section}\n"
        end
      end
      file.write " */"
    end
    
    puts "Preparing section assets done.\n\n"
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

  desc 'Creates empty asset containers'
  task :reset_asset_containers do
    puts "Cleaning up section asset containers."

    # Clean up JS asset container.
    File.open "app/assets/javascripts/application_sections.js", 'w' do |file|
      file.write <<-END_STR
// THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN
// AND MUST BE LOADED BY YOUR PAGE.
// PLEASE DO NOT MODIFY IT MANUALLY.
//
      END_STR
    end

    # Clean up CSS asset container.
    File.open "app/assets/stylesheets/application_sections.css", 'w' do |file|
      file.write <<-END_STR
/*
 * THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN.
 * AND MUST BE LOADED BY YOUR PAGE.
 * PLEASE DO NOT MODIFY MANUALLY.
 */
      END_STR
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
        next if view_file[-4..-1] == '.swp'
        view_path = File.join(dir, view_file)
        next if File.directory? "#{root}/#{view_path}"
        result << view_path
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
  
  def find_sections_in_section section_name
    puts "parsing section #{section_name}"
    paths = section_name.split '/'
    directory_name = paths[0..-2].join '/'
    puts "directory: #{directory_name}"
    directory_name += '/'
    file_name = paths[-1]
    puts "file name: #{file_name}"
    section_content = IO.read "app/sections/#{directory_name}#{file_name}/_#{file_name}.html.haml"

    result = section_content.scan(/\=\s*section\s+['":](.*?)['"]?$/).flatten.sort.uniq

    # TODO (KG): fix this
    puts "old sections: #{result}"
    new_result = result.map {|s| puts "cleanup: #{s}" ; s.ends_with?("',") ? s[0..-3] : s }
    puts "new_sections: #{new_result}"
    new_result
  end

  # Returns an array with the name of all sections in the given view source.
  def find_sections_in_view view_text
    erb_sections = view_text.scan(/<%=\s*section\s+['":]([^'",\s]+)%>/).flatten.sort.uniq
    haml_sections = view_text.scan(/\=\s*section\s+['":]([^"',\s]+)/).flatten.sort.uniq
    # TODO (KG): fix this
    puts "old haml: #{haml_sections}"
    new_haml = haml_sections.map {|s| puts "cleanup: #{s}" ; s.ends_with?("',") ? s[0..-3] : s }
    puts "new_haml: #{new_haml}"
    erb_sections + new_haml
  end
  
  # Returns whether the given file contains the given text somewhere in its content.
  def file_contains file_name, text
    IO.read(file_name) =~ text
  end
  
  # Returns the path to the asset in the given section.
  def asset_path section_name, asset_extension = nil, asset_prefix = nil
    split_names = section_name.split '/'
    filename = split_names[-1]
    directory = split_names[0..-2].join '/'
    directory += '/' if directory.size > 0
    "app/sections/#{directory}#{filename}/#{asset_prefix}#{filename}#{asset_extension}"
  end

  # Returns the relative path to the asset for the asset pipeline.
  def require_path section_name
    split_names = section_name.split '/'
    filename = split_names[-1]
    directory = split_names[0..-2].join '/'
    directory += '/' if directory.size > 0
    "../../sections/#{directory}#{filename}/#{filename}"
  end
end

# Run the 'sections:prepare' rake task automatically before the 'assets:precompile' rake task
# when the latter is called.
Rake::Task['assets:precompile'].enhance ['sections:prepare'] do
  Rake::Task["sections:reset_asset_containers"].invoke
end

