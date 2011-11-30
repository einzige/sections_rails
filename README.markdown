Ruby on Rails provides amazing infrastructure and conventions for well-structured serverside code. 
It falls short, however, for the view layer. 

_Partials_ are a way to break up the HTML code of complex web pages into individual sections, 
but no such facilities are available for CSS and JavaScript. 
As a result, the CSS and JS assets are either defined in a few huge files
(which are hard to maintain ond oftenly accumulate code that is no longer used)
or are broken up into smaller files located within the _/app/assets/javascripts_ and _app/assets/stylesheets_ folders,
but even then the different files have no correlation to each other because they are in different places.

_Sections_rails_ fills that gap by adding infrastructure to the view layer in Ruby on Rails
that allows to define the code (HTML, CSS, and JavaScript) of dedicated 
sections of the applications views in one place.

# Example

Let's assume a web page has a navigation menu on the left side. 
This menu requires certain HTML, CSS, and JavaScript code that is very specific to that menu.
_Sections_rails_ allows to define this code in a special folder structure:

    /app/sections/menu/_menu.html.erb
                       menu.css
                       menu.js

To display this menu in a view, simply do this:

    <%= section :menu %>

This inserts the partial as well as the JS and CSS files in the view.


# Installation

In your Gemfile:

    gem 'sections_rails'

Then set up the directory structure:

    $ rails generate sections

The generator does the following things:

1.  It create a new folder __/app/sections__,
    in which you put the source code for the different sections.

2.  It includes the folder /app/sections in the asset pipeline by adding this line into your _application.rb_ file:

        config.assets.paths << 'app/sections'

3.  It optionally creates a demo section called _hello_world_.


# Usage

To use the "hello_world" section created by the sections generator, simply put this in your views:

    <%= section :hello_world %>

All files inside a section folder are optional.
If the partial file is missing, _sections_rails_ would create the following empty div in the view instead.

    <div class="hello_world"></div>


## Asset precompilation

_Sections_rails_ provides facilities to include the assets of sections in the global asset
bundles for production mode.

1.  Run __rake rake sections:prepare__
    
    This rake task creates helper files that configure the asset pipeline to include the assets from the sections.

    * /app/assets/javascripts/application_sections.js: links to all JS files of all sections.
    * /app/assets/stylesheets/application_sections.js: links to all CSS files of all sections.

2.  Include the generated helper files into your _application.js_ and _application.css_ files.

3.  Run __rake assets:precompile__ as usual.


# Missing features

_Sections_rails_ is in early development and far from complete. Missing features are:

* Support for alternative formats for assets like CoffeeScript, Sass etc.
* Support for page-specific asset files.
* Better integration into asset precompilation.
