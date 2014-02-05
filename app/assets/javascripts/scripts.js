$(document).ready(function(){
	$('.banner_message').slideUp(0, function(){
		$('body').animate({opacity:1}, 100, function(){
			$('.banner_message').slideDown("fast", function(){
				$(this).animate({opacity:1}, 5000, function(){
					$(this).slideUp(600, function(){
						$(this).remove();
					});
				});
			});
		});
	});
	
	$('.banner_message').on('click', function(){
		$(this).stop().slideUp(600, function(){
			$(this).remove();
		});
	});
	
	$('.toggle_trigger').on('click', function(){
		$('#toggle_'+$(this).prop('id')).slideToggle();
	});
	
	$('.form_change select').on('change', function(){
		$(this).parents('form').submit();
	});
	
	$('#distribute_url').on('mouseover', function(){
		$(this).select();
	});


	$('textarea:not(".no_wysiwyg")').wysihtml5({
	    "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
	    "emphasis": true, //Italics, bold, etc. Default true
	    "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
	    "html": true, //Button which allows you to edit the generated HTML. Default false
	    "link": true, //Button to insert a link. Default true
	    "image": true, //Button to insert an image. Default true,
	    "color": true, //Button to change color of font
	    "size": 'sm' //Button size like sm, xs etc.
	});
});