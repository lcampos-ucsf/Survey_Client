
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

	//popover functionality trigger
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
			  	var id = j$(this).attr('id');
			  	var sid = id.split('_');
			  	if(sid[2] == 'radio' || sid[2] == 'multi')
			  		wipeErrorMsg(this);
			  },
			  change: function() {
			    if(!autosaveOn){
			  		autosaveOn = true;
			  	}
			  	wipeErrorMsg(this);
			  }, 
			  keyup: function(){
			  	wipeErrorMsg(this);
			  }
			  
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
		               // alert(errorTrown);
		            }
		        });
    		}
		});
	}


	//calculation component functionality
	j$('.calculation').each(function(){
		var parent_cal = this;
		var logic = j$(parent_cal).attr('data-calc-logic');
		//split logic, may have empty vals
		var l_a1 = logic.split(/[\(\)\-\*\+]+/);
		var inputs = j$('.edit_form_field');
		var inputs_ids = {};
		//array cleansing
		var l_arr = new Array();
		for (k in l_a1) if(l_a1[k]) l_arr.push(l_a1[k].replace(/^\s*|\s*$/g,''))

		//get valid input's id
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
		//alert('calculation 2');
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
				//hide error msg
				j$(parent_cal).prev().removeClass('errorhighlight');
				j$(parent_cal).prev().prev().css('display','none');

				var vl = eval(logic2)
				j$(parent_cal).prev().text(vl);
				j$(parent_cal).val('');
				j$(parent_cal).val( vl );

			});
		});
		
	});

  });//end ready function

  	function ff(elemId, value, id, type){
  		if(type == 'radio'){
			j$('.'+elemId).val(value);
		}else if (type == 'checkbox'){
			var vs = j$('.'+elemId).val();
			
			//this code needs revision
			var values = j$('input:checkbox:checked.'+elemId).map(function () {
			  return this.value;
			}).get();

			var vvv = values.join(';');

			j$('.'+elemId).val(values);
			values = '';

		}
	}

	function formsubmit(url, dir){

		var dt = j$("form").serialize();
		//dt += (dt ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
		j$.ajax({
			url: "/surveys/update_multiple",
			type: "POST",
			data: dt,
			async: false,
			headers: {'X-CSRF-Token': AUTH_TOKEN },
			dataType: "script",
			success: function(data){
				//alert('sucessful post');

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
				

			},
			error: function(data, textStatus){
				autosaveOn = false;
				var arr = eval(data.responseText);
				
				if ( !j$.isEmptyObject(arr[0]) ){
					for (var x = 0; x< arr.length; x++){  
						var s = arr[x];
						if(s != null){
						 	
						 	var el = s.id.split('_');
						 	var p_error;
						 	if(el[2] == 'radio')
						 		p_error = j$('#' + s.id).parent().parent().prev('p');
						 	else if(el[2] == 'multi'){
						 		//alert('id = '+s.id);
						 		p_error = j$('#' + s.id).parent().prev('p');
						 		j$('#' + s.id).css('display','block');
						 	}else if(el[2] == 'calculation'){
						 		p_error = j$('#' + s.id).prev().prev('p');
						 		j$('#' + s.id).prev().addClass('errorhighlight');
						 	}else{
								p_error = j$('#' + s.id).prev('p');
							}
							p_error.text(s.msg);
							p_error.css('display','block');
							j$('#' + s.id).addClass('errorhighlight');
						}
					}
				}
			}

		});

		
	}

	function ajaxautosave(){

		if (autosaveOn) {
			var dt = j$("form").serialize();
			//dt += (dt ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
			dt += (dt ? "&" : "") + "as=true";

			j$.ajax({
				url: "/surveys/update_multiple",
				type: "POST",
				data: dt,
				async: true,
				headers: {'X-CSRF-Token': AUTH_TOKEN },
				success: function(data){

					if ( !j$.isEmptyObject(data[0]) ){
						for (var x = 0; x< data.length; x++){  
						 var s = data[x];
						 var n_id = s.key+s.id;
						 j$('#' + s.key).attr('name',n_id);
						 j$('#' + s.key).attr('id',n_id);
						}
					}

					var timestamp = new Date();
					var hrs = timestamp.getHours();
					var mins = timestamp.getMinutes();
					var ap = hrs < 12 ? "AM" : "PM";
					hrs = hrs > 12 ? hrs - 12 : hrs;
					mins = mins < 10 ? '0' + mins : mins; 

					j$('#autosaved').text('Draft saved at '+ hrs + ':' + mins + ' '+ap );
					autosaveOn = false;
				},
				error: function(data, textStatus){
					autosaveOn = false;
					//alert('error2 = '+data['responseText']);
					var arr = eval(data.responseText);
					
					if ( !j$.isEmptyObject(arr[0]) ){
						for (var x = 0; x< arr.length; x++){  
						 var s = arr[x];
						 if(s != null){
						 	
						 	var el = s.id.split('_');
						 	var p_error;
						 	if(el[2] == 'radio')
						 		p_error = j$('#' + s.id).parent().parent().prev('p');
						 	else{
								p_error = j$('#' + s.id).prev('p');
							}
							p_error.text(s.msg);
							p_error.css('display','block');
							j$('#' + s.id).css('border','1px solid red');
						}
						}
					}
					
				}

			});
			
		}
	}

	function wipeErrorMsg(elem){
		var eId = j$(elem).attr('id').replace('[]','');
	  	var eAr = eId.split('_');
		var p_error;
		if(eAr[2] == 'radio')
			p_error = j$('#' + eId).parent().parent().prev('p');
		else if(eAr[2] == 'multi'){
			p_error = j$('#' + eId).parent().prev('p');
		}else{
			p_error = j$('#' + eId).prev('p');
		}
		p_error.css('display','none');
		j$(elem).removeClass('errorhighlight');
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






	