namespace :sections do
  include SectionsRails::Helpers

  desc "Prepares the assets for precompilation in a setup with a single application.js file"
  task :prepare do
    print "\nPreparing sections assets ..." ; STDOUT.flush

    # Find all sections used in the views.
    sections = find_all_views('app/views').map do |view|
      find_sections IO.read "app/views/#{view}"
    end.flatten.sort.uniq
    
    # Find all sections within the already known sections.
    i = 0
    while i < sections.size
      section = sections[i]
      referenced_sections = find_sections_in_section section
      referenced_sections.each do |referenced_section|
        sections << referenced_section unless sections.include? referenced_section
      end
      i += 1
    end
    sections.sort!
    
    # Create the require file for application.js.
    File.open "app/assets/javascripts/application_sections.js", 'w' do |file|
      sections.each do |section_name|
        section = SectionsRails::Section.new section_name
        js_asset = section.find_js_asset_path
        file.write "//= require #{js_asset}\n" if js_asset
      end
    end
    
    # Create the require file for application.css.
    File.open "app/assets/stylesheets/application_sections.css", 'w' do |file|
      file.write "/*\n"
      sections.each do |section_name|
        section = SectionsRails::Section.new section_name
        js_asset = section.find_js_asset_path
        file.write "//= require #{js_asset}\n" if js_asset
      end
      file.write " */"
    end
    
    puts " done.\n\n"
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

  # Used for :prepare_pages. Not used right now.
  def parse_views views
    result = {}
    views_to_parse.each do |view_to_parse|
      view_text = IO.read(File.join root, view_to_parse)
      result[view_to_parse] = find_sections_in_text view_text
    end
    result
  end
  

  def find_sections_in_section section_name
    section = SectionsRails::Section.new section_name
    partial_path = section.find_partial_filename
    if partial_path
      find_sections IO.read partial_path
    else
      []
    end
  end

  # Returns the path to the asset in the given section.
  def asset_path section_name, asset_extension = nil, asset_prefix = nil
    directory, filename = split_path section_name
    "app/sections/#{directory}#{filename}/#{asset_prefix}#{filename}#{asset_extension}"
  end

  # Returns the relative path to the asset for the asset pipeline.
  def require_path section_name
    directory, filename = split_path section_name
    "../../sections/#{directory}#{filename}/#{filename}"
  end
end

# Run the 'sections:prepare' rake task automatically before the 'assets:precompile' rake task
# when the latter is called.
Rake::Task['assets:precompile'].enhance ['sections:prepare'] do
  Rake::Task["sections:reset_asset_containers"].invoke
end

