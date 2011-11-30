Ruby on Rails provides an amazing infrastructure and conventions for well structured server-side code. 
It falls, however, short for the view layer. 

_Partials_ provide a nice way to represent the HTML code of individual sections within complex web pages, 
but no such facilities are available for the corresponding CSS and JavaScript. 
This leaves the task of organizing the JS and CSS completely up to the user.

_Sections_rails_ fills this gap by adding infrastructure to the view layer of Ruby on Rails.
It allows to define and use the HTML, CSS, and JavaScript code of dedicated 
sections of pages together in one place.


# Example

Let's assume a web page has amongst other things a navigation menu.
This menu requires certain HTML, CSS, and JavaScript code that is specific to it.
_Sections_rails_ allows to define this code as a _section_ inside the _/app_ folder:

    /app/sections/menu/_menu.html.erb
                       menu.css
                       menu.js

To display this menu, simply do this in your view:

    <%= section :menu %>

This inserts the partial as well as the JS and CSS files from _/app/sections/menu_ at this location.


# Installation

In your Gemfile:

    gem 'sections_rails'

Then set up the directory structure:

    $ rails generate sections

The generator does the following things:

1.  It creates a new folder __/app/sections__,
    in which you put the source code for the different sections.

2.  It includes the folder _/app/sections_ in the asset pipeline by adding this line into your _application.rb_ file:

        config.assets.paths << 'app/sections'

3.  It optionally creates a demo section called _hello_world_.


# Usage

To use the "hello_world" section created by the sections generator, simply add it to the view:

    <%= section :hello_world %>

If your section renders itself completely in JavaScript, you can omit the partial file for this section.
In this case, _sections_rails_ creates an empty div in the view.

    <div class="hello_world"></div>


## Asset precompilation

_Sections_rails_ provides facilities to include the assets of sections in the global asset
bundles for production mode.

1.  Run __rake sections:prepare__
    
    This rake task creates helper files that tell the asset pipeline about the assets of the different sections.

    * _/app/assets/javascripts/application_sections.js_ links to all JS files of all sections.
    * _/app/assets/stylesheets/application_sections.js_ links to all CSS files of all sections.

2.  Include the generated helper files into your _application.js_ and _application.css_ files.

    In application.js:
    
        //= require application_sections

    In application.css:
    
        /*= require application_sections */    

3.  Run __rake assets:precompile__ as usual.


# Missing features

_Sections_rails_ is in early development and far from complete. Missing features are:

* Support for alternative asset formats like CoffeeScript, Haml, Sass etc.
* Support for page-specific asset files.
* Better integration into the asset precompilation workflow.
