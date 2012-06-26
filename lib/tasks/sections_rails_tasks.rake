require 'sections_rails/view_finder'

namespace :sections do

  desc "Prepares the assets for precompilation in a setup with a single application.js file"
  task :prepare do
    puts "\nPreparing sections assets:"

    sections = SectionsRails::ViewFinder.find_all_views('app/views').map do |view| 
      SectionsRails::PartialParser.find_sections(IO.read view).map do |section_name|
        sections = SectionsRails::Section.new(section_name).referenced_sections
        sections << section_name
        puts "* #{section_name}: #{sections.join ', '}"
        sections
      end
    end.flatten.sort.uniq
    puts ''
    
    # Create the require file for application.js.
    File.open "app/assets/javascripts/application_sections.js", 'w' do |file|
      sections.each do |section_name|
        section = SectionsRails::Section.new section_name
        js_asset = section.find_js_includepath
        file.write "//= require #{js_asset}\n" if js_asset
      end
    end
    
    # Create the require file for application.css.
    File.open "app/assets/stylesheets/application_sections.css", 'w' do |file|
      file.write "/*\n"
      sections.each do |section_name|
        section = SectionsRails::Section.new section_name
        css_asset = section.find_css_includepath
        file.write " *= require #{css_asset}\n" if css_asset
      end
      file.write " */"
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


  def find_sections_in_section section_name
    section = SectionsRails::Section.new section_name
    SectionsRails::Section.find_sections section.partial_content
  end
end

# Run the 'sections:prepare' rake task automatically before the 'assets:precompile' rake task
# when the latter is called.
Rake::Task['assets:precompile'].enhance ['sections:prepare'] do
  Rake::Task["sections:reset_asset_containers"].invoke
end

