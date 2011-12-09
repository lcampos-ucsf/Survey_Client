var j$ = jQuery.noConflict();

j$(document).ready(function(){
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
  j$("body").bind("click", function (e) {
    j$('a.menu').parent("li").removeClass("open");
  });

  j$("a.menu").click(function (e) {
    var j$li = j$(this).parent("li").toggleClass('open');
    return false;
  });

});