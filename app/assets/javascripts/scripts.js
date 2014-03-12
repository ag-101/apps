$(document).ready(function(){
	$('.banner_message').slideUp(0, function(){
		$('body').animate({opacity:1}, 100, function(){
			$('.banner_message').slideDown("fast", function(){
				$(this).animate({opacity:1}, 7000, function(){
					$(this).slideUp(600, function(){
						$(this).remove();
					});
				});
			});
		});
	});
	
	$('body').on('click', '.slide_toggle', function(e){
		$(this).parents('.panel').find('.slide_up').slideDown();
		$(this).removeClass('slide_toggle');
		
		var pos = $(this).offset();
	    $('body').animate({ scrollTop: (pos.top - 10) });		
	});
	
	$('#enable_workflow_controls').on('click', function(e){
		$('.hidden_workflow').removeClass('hidden');
		$(this).remove();
		e.preventDefault();
	});
	
	
	$('.slide_up').slideUp(0);
	
	$('body').on('click', '.workflow_item.toggler', function(){
		$(this).parents('.col-sm-4').find('.workflow_item.slide_up').slideDown();
		$(this).slideUp();
	});
	
	$('.banner_message').on('click', function(){
		$(this).stop().slideUp(600, function(){
			$(this).remove();
		});
	});
	
	$('body').on('change', '#workflow_stage_send_to_id', function(){
		$(this).parents('form').submit();
	});
	
	$('.toggle_trigger').on('click', function(){
		$('#toggle_'+$(this).prop('id')).slideToggle();
	});
	
	$('body').on('click', '.remove_stage', function(e){
		ajax_call($(this).prop('href'), 'json', 'post', {"_method":"delete"}, $(this).parents('.workflow_stage_container'), slide_up_remove);
		return false;
	});
	
	$('body').on('click', '#new_stage a', function(e){
		ajax_call($(this).prop('href'), 'html', 'get', '', $(this), load_form);
		e.preventDefault();
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
	
	$('.admin_link').fadeOut(0);
	$('.admin_button').on('click', function(){
		show_admin_buttons('fast');
	});
	
	if ($('.nav .active').find('.admin_link').length > 0){
		show_admin_buttons(0);
	}
	
	$('.validate_form').on('click', function(e){
		validate_form($(this).parents('form'), $(this).prop('type'));
		e.preventDefault();
	});
});

function validate_form(form, button_type){
	$('.error.field_with_errors').removeClass('error').removeClass('field_with_errors');
	$('.panel-danger').removeClass('panel-danger').addClass('panel-default');
	$('#notice').html('');
	
	var form_valid = true;
	var errors = [];
	$(form).find('.required').each(function(){
		var parent = $(this).parents('.form-group');
		var app_type = parent.prop('class').split(" ");



		switch (app_type[1]){
			case 'select':
			case 'text_field':
			case 'textarea':
			case 'table_vertical':
			case 'table_horizontal':
				if (parent.find('select, input, textarea').val() == ''){
					errors.push(parent);
					form_valid = false;
				}				
			break;
			case 'radio':
			case 'checkbox':
				if (parent.find('input:checked').length == 0){
					errors.push(parent);
					form_valid = false;
				}
			break;
		}
	});
	if (form_valid == true){
		if(button_type == "submit"){
			$('#draft').val('0');
			$(form).submit();
		} else{
			$('#draft').val('1');
			$(form).submit();
		}
		
	} else{
		$('#notice').html('<div class="alert alert-danger">One or more mandatory fields have not been completed.</div>');
		$('#notice .alert').slideUp(0, function(){
			$(this).slideDown("fast", function(){
				$(this).animate({opacity:1}, 3000, function(){
					$(this).slideUp();
				});
			});
		});
		for (var i = 0; i < errors.length; i++) {
			errors[i].addClass('field_with_errors').addClass('error');
			errors[i].parents('.panel-default').removeClass('panel-default').addClass('panel-danger');
		};
		page_id = errors[0].parents('.page').prop('id').split('page_');
		display_page(page_id[1], 100);
	}
}

function ajax_call(url, dataType, type, data, object, callback){
	$.ajax({
		  url: url,
		  dataType: dataType,
		  type: type,
		  data: data,
		  async: false
		}).success(function(response, status) {
			callback(object, response, status);
		}).error(function(response, status){
			alert("There was an error.");
		});
}


function load_form(object, response, status){
	$('.workflow_stage_container.hidden').clone().insertBefore($('#final_stage')).removeClass('hidden').slideUp(0, function(){
		$(this).find('.workflow_stage').html(response);
		$(this).slideDown();
	});
}

function slide_up_remove(object, response, status){
	object.slideUp("fast", function(){
		 $(this).remove(); 
	 });
}

function show_admin_buttons(speed){
	$('.admin_button').fadeOut(speed, function(){
		$('.admin_link').fadeIn(speed);
	});
}