#= require ./content
#= require ./greetings

# This file contains the JavaScript for the 'hello client' section.
#
# It renders the content from embedded JST templates that are part of this section.
# i.e. the <div> with the class 'hello_world'.
$ ->
  $('.hello_client').html(JST['hello_client/content']())
                    .click(-> alert JST['hello_client/greetings']())

