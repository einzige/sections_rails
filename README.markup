# SectionsRails

Rails provides amazing infrastructure and conventions for serverside code. 
For the view layer, however, it falls short. 
It does provide _partials_ to break up the HTML code into individual sections, 
but no such facilities are available for CSS and JavaScript. 
As a result, these assets are either defined in a few huge files, or in smaller ones which
have no correlation to each other.

_sections-rails_ fills that gap by adding infrastructure to the view layer in Ruby on Rails
that represents the code (HTML, CSS, and JavaScript) of dedicated 
sections of the applications views in separate files.

## Example

Let's assume a web page has a navigation menu on the left side. This menu contains of
certain HTML, CSS, and JavaScript code. _Sections_rails_ allows to define all three types
of code in one place:

    /app/sections/_menu.html.erb
                  menu.css
                  menu.js

To render the menu in your view, and include all the necessary CSS and JS files, simply do this:

    <%= section :menu %>



## Installation

In your Gemfile:

    gem 'sections_rails'

Set up the directory structure:

    rails generate sections

The generator does the following things:

1.  It create a new folder __/app/sections__,
    in which you put the source code for the different sections.
    To make that easier, it also creates a demo section called "hello_world".
    Inside the folder __/app/sections/hello_world__ you find the files _hello_world.html.erb_,
    _hello_world.css_, and _hello_world.js_, which define the HTML, CSS, and JS code for this section.

2.  It includes the folder /app/sections into the asset pipeline by adding this line into your _application.rb_ file:
        config.assets.paths << 'app/sections'

3.  It optionally creates a demo section called "hello_world".


## Usage

To use the "hello_world" section, simply put this in your views:

    <%= section :hello_world %>

All files inside a section folder are optional. Missing CSS and JS files are simply omitted.
If the partial file is missing, _sections_rails_ would create the following empty div in the view instead.

    <div class="hello_world"></div>


## Asset precompilation

_sections_rails_ provides facilities to include the assets of sections in the global asset
bundles.

1.  Run __rake rake sections:prepare__
    This rake task creates helper files that configure the asset pipeline to include the assets from the sections.

    * /app/assets/javascripts/application_sections.js
    * /app/assets/stylesheets/

2.  Include the generated helper files into your _application.js_ and _application.css_ files.

3   Run rake assets:precompile


## Missing features

_Sections_rails_ is in early development and far from complete. Missing features are:

* Support for alternative formats for assets like CoffeeScript, Sass etc
* Support for page-specific asset files
* better integration into asset precompilation

