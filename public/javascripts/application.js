
var j$ = jQuery.noConflict();
var autosaveOn = false;

// For use within normal web clients 
var isiPad = navigator.userAgent.match(/iPad/i) != null;

// For use within iPad developer UIWebView
// Thanks to Andrew Hedges!
var ua = navigator.userAgent;
var isiPad = /iPad/i.test(ua) || /iPhone OS 3_1_2/i.test(ua) || /iPhone OS 3_2_2/i.test(ua);

  j$(document).ready(function() {
  	//Add datepicker calendar to inputs
  	if ( j$('form .datepicker')[0] ) { //do something 
	  	j$('form .datepicker').each(function(){
			j$(this).datepicker({ dateFormat: 'mm/dd/yy' });
			j$(this).live('click',  function(){
				var h = j$(this).height();  
				var st = j$(this).offset();  
				var t = st.bottom;
				var l = st.left;
				var uidatepicker = j$('.ui-datepicker');
				uidatepicker.css('top',t+'px');
				uidatepicker.css('left',l+'px');
				uidatepicker.css('font-size','11px');
			});
		});
	}

	//Add progressbar
	if ( j$('#pb')[0] ) { //do something 
		//j$('#pb').progressbar({ value: '<%= @progressbar.to_i %>' });
	}

	// toggles the survey description when click on link  
	if ( j$('.description-toggle')[0] ) {

		j$('.description-toggle').each(function(){
			//alert('each toggle, this.class = '+j$(this).class)
			j$(this).click(function() {
				//alert('inside click functionality');
				//j$(this).find('.desc_content').toggle(400);
				j$(this).siblings('.desc_content').toggle('slow');
				return false;
			});
		});
	}

	//j$('#wua').popover('show');
	if ( j$("a[rel=popover]") ) {
		j$(function () {
			j$("a[rel=popover]")
				.popover({
					offset: 10
				})
				.click(function(e) {
					e.preventDefault()
			});
		}); 
	}

	//Add autosave events to surveys
	if( j$('form')[0] ) {

		//Eliminates cache for every form
		j$('form').each(function() {
	       this.reset();
	    });

		if (isiPad) {
			//fixes onclick issue on nav buttons with ipad
			//next btn
			var n_btn = j$('#nextbtn');
			n_btn.click(function(){
					var oc = n_btn.attr('onclick');
					var u = oc.split("'");
					var url = u[1];
					formsubmit(url,'1');
			});

			//review btn
			var r_btn = j$('#reviewbtn');
			r_btn.click(function(){
					var oc = r_btn.attr('onclick');
					var u = oc.split("'");
					var url = u[1];
					formsubmit(url,'1');
			});

			//preview btn
			var p_btn = j$('#previewbtn');
			p_btn.click(function(){
					var oc = p_btn.attr('onclick');
					var u = oc.split("'");
					var url = u[1];
					formsubmit(url,'0');
			});
		}
		
		setInterval(function() { ajaxautosave(); }, 1000*60); // 1000ms * 60s = 1m
		j$('form input.edit_form_field, form textarea.edit_form_field, form select.edit_form_field').each(function (i) {
			j$(this).live({
			  click: function() {
			    if(!autosaveOn){
			  		autosaveOn = true;
			  	}
			  },
			  change: function() {
			    if(!autosaveOn){
			  		autosaveOn = true;
			  	}
			  }/*,
			  focus: function() {
			    if(!autosaveOn){
			  		autosaveOn = true;
			  	}
			  }*/
			});					
		});
	}//end if

	//Add tablesorter 
	if( j$('.tablesorter')[0] ){
		//invite all
		j$('.tablesorter.inviteall_tb').tablesorter({ 
	        headers: { 
	            0: { sorter: false }, 
	            1: { sorter: false }
	        } 
    	}); 

    	//invite index
    	j$(".tablesorter.inviteindex_tb").tablesorter({ 
	        headers: { 
	            0: { sorter: false }, 
	            1: { sorter: false },
	            7: { sorter:false } 
	        } 
    	}); 
	}//end if

	//autocomplete functionality
	if( j$('.autocomplete_comp')[0] ){

		j$('.autocomplete_comp').autocomplete({
			//minLength: 2,
			source: function(request, response) {
		        j$.ajax({
		            url: "/surveys/autocompletequery",
		            data: "{}",
		            dataType: "json",
		            headers: {'X-CSRF-Token': AUTH_TOKEN },
		            type: "POST",
		            contentType: "application/json; charset=utf-8",
		            success: function(data) {
		            	/*
		            	var list = j$.map(data, function(item) {
		                    return {
		                        value: item.Name
		                         	
		                    }
		                });
		                alert('data = '+list);
		                var re = j$.ui.autocomplete.escapeRegex(request.term);
				        var matcher = new RegExp( "^" + re, "i" );
				        var a = j$.grep( wordlist, function(item,index){
				            return matcher.test(item);
				        });
				        response( a ); */

		               	response(j$.map(data, function(item) {
		                    return {
		                        value: item.Name
		                    }
		                }))
		            },
		            error: function(XMLHttpRequest, textStatus, errorThrown) {
		                alert(errorTrown);
		            }
		        });
    		}
		});
	}


	//calculation component functionality
	j$('.calculation').each(function(){
		var parent_cal = this;
		var logic = j$(parent_cal).attr('data-calc-logic');
		var l_arr = logic.split(/[\-\*\+]+/);
		var inputs = j$('.edit_form_field');
		var inputs_ids = {};

		for(var l = 0; l < inputs.length; l++){
			for(var s = 0; s < l_arr.length; s++ ){
				var idd = inputs[l].id;
				var id2 = idd.split('_');
				l_arr[s] = l_arr[s].replace(/^\s*|\s*$/g,'');
				id2[1] = id2[1].replace(/^\s*|\s*$/g,'');

				if(id2[1] == l_arr[s]){
					var child = inputs[l].id;
					inputs_ids[l_arr[s]] = child;
				}
			}
		}
		
		j$.each(l_arr, function(){
			j$('#'+inputs_ids[this]).change(function(){
				var dict = {};
				var logic2 = logic;
				//get values for logic	
				for(var i = 0; i < l_arr.length; i++){
					var val = j$('#'+inputs_ids[l_arr[i]]).val();
					dict[l_arr[i]] = val ? val : 0 ;
				}
				//replace values on logic string
				for(var j=0; j<l_arr.length; j++){
					logic2 = logic2.replace(l_arr[j], dict[l_arr[j]]);
				}
				j$(parent_cal).val( eval(logic2) );

			});
		});
		
	});

	//optional to override real .html() if you want
  // $.fn.html = $.fn.formhtml;
/*	var oldHTML = j$.fn.html;

	j$.fn.formhtml = function() {
		if (arguments.length) return oldHTML.apply(this,arguments);
		j$("input,button", this).each(function() {
		  this.setAttribute('value',this.value);
		});
		j$("textarea", this).each(function() {
		  // updated - thanks Raja!
		  this.innerHTML = this.value;
		});
		j$("input:radio,input:checkbox", this).each(function() {
		  // im not really even sure you need to do this for "checked"
		  // but what the heck, better safe than sorry
		  if (this.checked) this.setAttribute('checked', 'checked');
		  else this.removeAttribute('checked');
		});
		j$("option", this).each(function() {
		  // also not sure, but, better safe...
		  if (this.selected) this.setAttribute('selected', 'selected');
		  else this.removeAttribute('selected');
		});
		return oldHTML.apply(this);
	};
	*/

  



  });//end ready function

	function formsubmit(url, dir){

		var dt = j$("form").serialize();
		dt += (dt ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
		j$.ajax({
			url: "/surveys/update_multiple",
			type: "POST",
			data: dt,
			async: false,
			dataType: "script",
			success: function(data){
				//alert('sucessful post');

			},
			error: function(){
				//alert('error on post');
			}

		});

		if(url.match("review") == null){
			if(url.match(/page/) == null ){
				if(url.match(/dir=[0-9]+/) == null){
					url = url+'?page=1';
				}else{
					url = url+'&page=1';
				}
			}
			if(url.match(/dir=[0-9]+/) != null)
				url = url.replace(/dir=[0-9]+/,'dir='+dir);
			else
				url = url+'&dir='+dir;
		}
		window.location = url;
	}

	function ajaxautosave(){

		if (autosaveOn) {
			var dt = j$("form").serialize();
			dt += (dt ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);

			j$.ajax({
				url: "/surveys/update_multiple",
				type: "POST",
				data: dt,
				async: true,
				success: function(data){

					//alert('empty data object? = '+ j$.isEmptyObject(data[0]) );
					//alert('execute if = '+ !j$.isEmptyObject(data[0]) );
					if ( !j$.isEmptyObject(data[0]) ){
						for (var x = 0; x< data.length; x++){  
						 var s = data[x];
						 var n_id = s.key+s.id;
						 j$('#' + s.key).attr('name',n_id);
						}
					}
				},
				error: function(){
					//alert('error on post');
				}

			});
			var timestamp = new Date();
			var hrs = timestamp.getHours();
			var mins = timestamp.getMinutes();
			var ap = hrs < 12 ? "AM" : "PM";
			hrs = hrs > 12 ? hrs - 12 : hrs;
			mins = mins < 10 ? '0' + mins : mins; 

			j$('#autosaved').text('Draft saved at '+ hrs + ':' + mins + ' '+ap );
			autosaveOn = false;
		}
	}

	// JavaScript
	//function loadScript(src, callback) {
	function loadScript(src) {
	    var head = document.getElementsByTagName('head')[0],
	        script = document.createElement('script');
	    done = false;
	    script.setAttribute('src', src);
	    script.setAttribute('type', 'text/javascript');
	    script.setAttribute('charset', 'utf-8');
	    script.onload = script.onreadstatechange = function() {
	        if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {
	            done = true;
	            script.onload = script.onreadystatechange = null;
	            }
	    }
	    //head.insertBefore(script, head.firstChild);
	    head.insertBefore(script, head.lastChild);
	}






	