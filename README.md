_Sections_rails_ adds a component-oriented infrastructure to the view layer of Ruby on Rails.
This allows to define and use the HTML, CSS, and JavaScript code of dedicated 
sections of web pages together in one place.


# Example

Let's take the navigation menu within a web site as an example section.
It consists of certain HTML, CSS, and JavaScript code as well as image resources. 
These assets must be loaded on every page that this navigation menu is visible on,
and should be removed when the navigation menu is removed from the site.

_Sections_rails_ allows to define these assets together, as a _section_ inside the _/app_ folder:

    /app/sections/menu/_menu.html.erb
                       menu.css
                       menu.js

To display this menu, simply do this in your view:

```erb
<%= section :menu %>
```

The _section_ helper inserts the partial as well as the JS and CSS files from _/app/sections/menu_ at this location.
It does the right thing in all circumstances: In development mode, it inserts the individual assets. 
In production mode, it inserts the assets to the main _application.js_ bundle.


# Installation

In your Gemfile:

```ruby
gem 'sections_rails'
```

Then set up the directory structure:

```bash
$ rails generate sections
```

The generator does the following things:

1.  It creates a new folder __/app/sections__,
    in which you put the source code for the different sections.

2.  It adds the folder _/app/sections_ to the asset pipeline by inserting this line into your _application.rb_ file:

        config.assets.paths << 'app/sections'

3.  It optionally creates a demo section called _hello_world_ that you can try out as described below.


In it's current prototypical implementation, _Sections_rails_ also creates empty asset container files:
__application_sections.js__ and __application_sections.css__.
Make sure you require them from your main _application.js_ and _application.css_ files. 
They are used only when running _rake assets:precompile_ during deployment, and should be checked in and stay the way they are. 


# Usage

To use the "hello_world" section created by the sections generator, simply add it to the view:

```erb
<%= section :hello_world %>
```

If your section renders itself completely in JavaScript, you can omit its partial file.
In this case, the _sections_ helper creates an empty div in the view.

```html
<div class="hello_world"></div>
```


# Missing features

_Sections_rails_ is in prototypical development and far from complete. Missing features are:

* Support for multiple application assets, for example page-specific compiled asset files instead of one global one.
* Support for assets in different formats like CoffeeScript, Haml, Sass etc.
* Support for serverside controller logic for sections, for example by integrating with https://github.com/apotonick/cells.
* More natural asset pipeline support by extending Sprockets to parse section calls.

