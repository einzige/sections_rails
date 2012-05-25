class SectionsGenerator < Rails::Generators::Base

  def create_sections_folder
    say ''
    say ' STEP 1: Creating sections folder'
    say ''
    empty_directory "app/sections"
    inject_into_file 'config/application.rb',
                     "    config.assets.paths << 'app/sections'\n",
                     :after => /config.assets.enabled\s*=.*\n/
    say ''
    say ' I have made some modifications to '
    say 'config/application.rb', Thor::Shell::Color::BOLD
    say ' Please review them before submitting these changes to your code repository.'
    say ''
  end
  
  def create_section_assets
    say ''
    say 'STEP 2: Creating asset manifests.'
    say ''
    create_file 'app/assets/javascripts/application_sections.js', <<-END_STR
// THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN
// AND MUST BE LOADED BY YOUR PAGE.
// PLEASE DO NOT MODIFY IT MANUALLY.
//
    END_STR

    create_file 'app/assets/stylesheets/application_sections.css', <<-END_STR
/*
 * THIS FILE IS AUTOMATICALLY CREATED BY THE SECTIONS PLUGIN.
 * AND MUST BE LOADED BY YOUR PAGE.
 * PLEASE DO NOT MODIFY MANUALLY.
 */
    END_STR

    say ''
    say ' I have created two files to reference the assets from the sections.'
    say ' * '
    say 'app/assets/javascripts/application_sections.js', Thor::Shell::Color::BOLD
    say ' * '
    say 'app/assets/stylesheets/application_sections.css', Thor::Shell::Color::BOLD
    say ''
    say ' They should be checked into your code repository the way they are, and remain that way.'
    say ' When running "rake assets:precompile" during deployment,'
    say ' they will be updated with the actually used assets for proper operation in production mode.'
    say ''
    say ' You must make sure they are loaded into the asset pipeline, for example by'
    say ' requiring them in application.js and application.css.'
    say ''
  end

  def create_sample_section
    say ''
    say 'STEP 3: Creating a sample section.'
    say ''
    
    # Ask the user.
    return unless ['', 'y', 'yes'].include? ask('Do you want to create a sample section? [Yn]').downcase

    # Create the sample section directory.
    empty_directory "app/sections/hello_world"

    # Create the partial.
    create_file "app/sections/hello_world/_hello_world.html.erb", <<-END_STR
<%# This file contains the HTML for the 'hello world' section. %>

<div class="hello_world">
  <h2>Hello World!</h2>
  This is content inside the hello world section!
</div>
    END_STR

    # Create the CSS file.
    create_file "app/sections/hello_world/hello_world.css", <<-END_STR
/* 
 * This file contains the CSS for the 'hello world' section. 
 *
 * Please note that all CSS in here should be relative to the container of the section,
 * in this case the ".hello" class.
 */

.hello_world { width: 300px; padding: 0 2ex 2ex; border: 2px dotted red; background-color: yellow; }
.hello_world .h2 { font-size: 1em; margin: 0 0 1ex; padding: 0; }
    END_STR
    
    # Create the JS file.
    create_file "app/sections/hello_world/hello_world.js", <<-END_STR
/*
 * This file contains the JavaScript for the 'hello world' section.
 *
 * Anything in here should be restrained to within the container of the section,
 * i.e. the <div> with the class 'hello_world'.
 */

$('.hello_world').click(function() {
  alert('The Hello World section says hello to the world! :)');
});
    END_STR

    say ''
    say ' A sample section has been created in '
    say 'app/sections/hello_world', Thor::Shell::Color::BOLD
    say ' To use it, simply put '
    say '<%= section :hello_world %>', Thor::Shell::Color::BOLD
    say ' into a view file.'
    say ''
    say ' Happy coding! :)'
    say ''
  end
end
