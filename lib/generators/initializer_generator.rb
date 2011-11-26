class InitializerGenerator < Rails::Generators::Base

  def create_sections_folder
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
  
  def create_sample_section
    
    # Ask the user.
    return unless ['', 'y', 'yes'].include? ask('Do you want to create a sample section? [Yn]').downcase

    # Create the sample section directory.
    empty_directory "app/sections/hello_world"

    # Create the partial.
    create_file "app/sections/hello_world/_hello_world.html.erb", <<-END_STR
<!-- This file contains the HTML for the 'hello world' section. -->

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
    say 'app/sections/sample_section', Thor::Shell::Color::BOLD
    say ' To use it, simply put '
    say '<%= section :sample %>', Thor::Shell::Color::BOLD
    say ' in your view file.'
    say ''
    say ' Happy coding! :)'
    say ''
  end
end
