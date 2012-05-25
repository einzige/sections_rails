/*
 * This file contains the JavaScript for the 'hello world' section.
 *
 * Anything in here should be restrained to within the container of the section,
 * i.e. the <div> with the class 'hello_world'.
 */

$(function() {
  $('.hello_world').click(function() {
    alert('The Hello World section says hello to the world!');
  });
});
