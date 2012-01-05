// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
var j$ = jQuery.noConflict();

  j$(document).ready(function() {

  	if ( j$('.datepicker')[0] ) { //do something 
	  	j$('.datepicker').each(function(){
			j$(this).datepicker({ dateFormat: 'mm/dd/yy' });
			j$(this).live('click',  function(){
				var h = j$(this).height();  
				var st = j$(this).offset();  
				var t = st.bottom;
				var l = st.left;
				j$('.ui-datepicker').css('top',t+'px');
				j$('.ui-datepicker').css('left',l+'px');
				j$('.ui-datepicker').css('font-size','11px');
			});
		});
	}
  });