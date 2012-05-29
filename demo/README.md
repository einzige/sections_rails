# SectionsRails Demo App

This is a sample Rails app that demonstrates how to use different forms of sections in Rails.


# Sample Sections
The app provides several sections as examples how to use them. 


## Hello World
The most basic section. It uses serverside templating, with some section specific JavaScript and CSS.


## Hello Future
Since SectionsRails uses Rails' asset pipeline, you can use any file format supported by it.
This section is the same section as _hello world_, just written in CoffeeScript, HAML, and SASS.


## Hello Client
A more AJAXy section, rendered on the client using a clientside templating engine. 
This example demonstrates not only how to implement very AJAXy code using sections, 
but also that sections can contain any type of additional objects that are supported by Rails' asset pipeline,
in this case JST templates.

Please note that you have to require any additional files you want to use, like the JST files in this example, in your JavaScript/CoffeeScript file.
This allows you to keep several templates/files around, and only use what you actually need. 

Sections supports any templating technology that is available to the Asset Pipeline in Rails, for example _EJS_, _ECO_ etc.

