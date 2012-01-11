
var j$ = jQuery.noConflict();
var autosaveOn = false;

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

	//Add autosave events to surveys
	if( j$('form')[0] ) {

		if (isiPad) {
			var n_btn = j$('#nextbtn');
			n_btn.click(function(){
					var url = n_btn.attr('l');

					alert("live event next click, url = "+url );
					formsubmit(url,'1');
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
			  },
			  focus: function() {
			    if(!autosaveOn){
			  		autosaveOn = true;
			  	}
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
	            1: { sorter: false },
	            8: { sorter:false } 
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

  });//end ready function

  	// For use within normal web clients 
	var isiPad = navigator.userAgent.match(/iPad/i) != null;

	// For use within iPad developer UIWebView
	// Thanks to Andrew Hedges!
	var ua = navigator.userAgent;
	var isiPad = /iPad/i.test(ua) || /iPhone OS 3_1_2/i.test(ua) || /iPhone OS 3_2_2/i.test(ua);

	if (isiPad) {
	var a = document.getElementsByTagName("a");
	for(var i=0;i<a.length;i++)
	{
	    a[i].onclick=function()
	    {
	        window.location=this.getAttribute("href");
	        return false
	    }
	}
	}

	function formsubmit(url, dir){

		j$.ajax({
			url: "/surveys/update_multiple",
			type: "POST",
			data: j$("form").serialize(),
			async: false,
			dataType: "script",
			success: function(){
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
			 j$.ajax({
				url: "/surveys/update_multiple",
				type: "POST",
				data: j$("form").serialize(),
				async: false,
				success: function(){
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






	