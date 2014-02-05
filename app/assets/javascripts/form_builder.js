$(document).ready(function(){	
	init_drag();
	
	$('body').on('click', '.option', function(e){
		$(this).toggle({"width":"0px"}, function(){
			$(this).remove();
		});
		e.preventDefault();
	});
	
	$('body').on('submit', '.disabled_form', function(e){
		e.preventDefault();
	});
	
	$('body').on('click', '.field_label, .option_name', function(){
		$(this).select();
	});
	
	$('body').on('change', '#options_modal input', function(){
		if($(this).val() == ""){
			$(this).slideUp("fast", function(){
				$(this).remove();
			});
		}
	});
	
	$('body').on('click', '.remove_field', function(e){
		$(this).parents('li').animate({"margin-left":"-100%"}, function(){
			$(this).height($(this).height());
			$(this).css("min-height","0px");
			$(this).slideUp("fast", function(){
				$(this).remove();
				update_content();
			});
		});
		e.preventDefault();
	});
	
	$('body').on('click', '#options_save', function(e){
		parent = $('#'+$('#modal_target').val());
		parent.find('.options .option').remove();
		
		$('#options_modal .edited_options .option_name').each(function(){
			if($(this).val() != ""){
				parent.find('.options').append(parent.find('.default_option_display').html());
				if(parent.find('.options .option').last().find('.option_text').length > 0){
					parent.find('.options .option').last().find('.option_text').text($(this).val());
				} else{
					parent.find('.options .option').last().text($(this).val());
				}
			}
		});
		
		$('#options_modal').modal('hide');
		update_preview(parent);
		e.preventDefault();
	});
	
	$('body').on('click', '#add_option', function(e){
		html = $('#options_modal .default_option').html();
		$('#options_modal .edited_options').append(html);
		$('#options_modal .edited_options input').last().slideUp(0, function(){
			$(this).slideDown();
		});
		e.preventDefault();
	});
	
	$('body').on('click', '.launch_modal', function(){
		$('.edited_options').html('');
		
		item = $(this).parents('li');
		$('#modal_target').val(item.prop('id'));
		
		items = item.find('.options .option').each(function(){
			html = $('#options_modal .default_option').html();
			$('#options_modal .edited_options').append(html);
			
			if ($(this).find('.option_text').length > 0){
				text = $(this).find('.option_text').text();
			} else{
				text = $(this).text();
			}
			
			$('#options_modal .edited_options .option_name').last().prop('value', text);
		});
		html = $('#options_modal .default_option').html();
		$('#options_modal .edited_options').append(html);
	});
	
	$('body').on('keyup', '.field_label', function(){
		value = $(this).val();
		if (value == ""){
			value = $(this).prop('placeholder');
		}
		$(this).parents('li').find('.li_handle h3 .text_content').removeClass('default_label').text(value);
		update_content();
	});
	
	$('body').on('change', '.required_checkbox', function(){
		if($(this).prop('checked') == true){
			$(this).parents('li').find('.li_handle h3').prepend("<span class='required'>*</span>");
		} else{
			$(this).parents('li').find('.li_handle h3 .required').remove();
		}
		update_content();
	});
	
	if($('#construct_content').length > 0){
		load_content();
	}	
});

function update_content(){
	var form_content = [];
	$('#fields .li_handle').each(function(){
		current_item = {};
		current_item.label = $(this).find('h3 .text_content').text();
		if ($(this).find('h3 .required').length > 0){
			current_item.required = true;
		} else{
			current_item.required = false;
		}
		
		if ($(this).find('.form_save_option').length > 0){
			current_item.options = [];
			
			$(this).find('.form_save_option').each(function(){
				current_item.options.push($(this).val());
			});
		}
		
		type = $(this).parents('li').prop('class').split(" ");
		
		var  this_object = {}; 
		this_object[type[0]] = current_item;
		
		form_content.push(this_object);
	});
	
	$('#construct_content').val(JSON.stringify(form_content));
}

function load_content(){
	objects = JSON.parse($('#construct_content').val());

	for (var object in objects){
		for (var field_type in objects[object]){
			$('#field_picker .'+field_type).clone().appendTo($('#fields ul'));
			var inserted_id = 'field_'+new Date().getTime();
			$('#fields li').last().prop('id', inserted_id);
			
			$('#'+inserted_id).find('.field_label').val(objects[object][field_type]['label']).trigger('keyup');
			
			if (objects[object][field_type]['required'] == true){
				$('#'+inserted_id).find(" .required_checkbox").prop('checked', true).trigger('change');
			}
			
			for (var option in objects[object][field_type]['options']){
				$('#'+inserted_id).find('.options').append($('#'+inserted_id).find('.default_option_display').html());
				if($('#'+inserted_id).find('.options .option').last().find('.option_text').length > 0){
					$('#'+inserted_id).find('.options .option').last().find('.option_text').text(objects[object][field_type]['options'][option]);
				} else{
					$('#'+inserted_id).find('.options .option').last().text(objects[object][field_type]['options'][option]);
				}
			}	
			
			update_preview($('#'+inserted_id));
		}
	}

	
	if ($('#fields li').length > 1){
		$('#drop_fields_here').slideUp(0);
	}		
	
	$('#fields .form_controls').fadeIn();	
}

function init_drag(){
	$( "#field_picker ul li" ).draggable({ 
		connectToSortable: '#fields ul',
			helper: 'clone',
			revert: 'invalid',
			opacity: '0.5',
			cursor: 'move',
			tolerance: 'pointer'
				
	});	
	
	$('#fields ul').droppable({
	      activate: function( event, ui ) {
	          $(this).addClass("alert-warning");
				$("#drop_fields_here").remove();       
	      },
	      deactivate: function( event, ui ) {
	          $(this).removeClass("alert-warning");
	      },    
	      over: function( event, ui ) {
	    	  $(this).removeClass("alert-warning");
	          $(this).addClass("alert-success");
	      },
	      out: function( event, ui ) {
	    	  $(this).addClass("alert-warning");
	          $(this).removeClass("alert-success");
	      },
	      drop: function( event, ui ) {
	          $(this).removeClass("alert-success");
	          update_content();
	      }	  	      
	});	
	
	$( "#fields ul" ).sortable({  revert:true,  tolerance: 'pointer', 
		items: "li:not(#drop_fields_here)",
		handle: '.li_handle',
		stop: function(event, ui) {

			$(this).find('.remove').not('input[type=text]').not('textarea').fadeTo(1000, 0.3);

			$("#drop_fields_here").slideUp("fast");
			$(this).find('.form_controls').fadeIn();
			
			if(ui.item.find('.field_label').val() == ""){
				ui.item.find('.li_handle h3 .text_content').animate({ opacity:0 },0 , function(){
					$(this).text(ui.item.find('.field_label').prop('placeholder'));
					$(this).animate({opacity:1}, "slow");
				});
			}
			
			if(ui.item.prop('id') == ""){
				ui.item.prop('id', 'field_'+new Date().getTime());
			}
			
			update_content();
		}
	});	
}

function update_preview(object){
	object.find('.remove').fadeTo(1000, 1, function(){
		$(this).removeClass('remove');
	});
	
	if(object.hasClass('radio_buttons') || object.hasClass('checkboxes')){
		object.find('.form_save_option, .li_handle .remove, .li_handle input, .li_handle .option_text, .li_handle br').remove();
		object.find('.options .option').each(function(){
			object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).find('.option_text').text()+'">');
			object.find('.li_handle').append($(this).html()+"<br/>");
		});
	}

	if(object.hasClass('select_box')){
		object.find('.li_handle select').prop('disabled', false).html('');
		object.find('.form_save_option').remove();
		object.find('.options .option').each(function(){
			object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
			object.find('.li_handle select').append("<option>"+$(this).text()+"</option>");
		});
	}
	
	if(object.hasClass('table_vertical')){
		object.find('table').remove();
		
		var table_html = '<table class="table table-striped table-bordered table-hover"><tr>';
		
		object.find('.options .option').each(function(){
			table_html += '<th>'+$(this).text()+'</th>';
			object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
		});		
		table_html += '</tr><tr>';
		
		object.find('.options .option').each(function(){
			table_html += '<td>&nbsp;</td>';
		});		
		table_html += '</tr>';
		
		table_html += "</table>";
		object.find('.li_handle').append(table_html);
	}
	
	if(object.hasClass('table_horizontal')){
		object.find('table').remove();
		
		var table_html = '<table class="table table-striped table-bordered table-hover">';
		
		object.find('.options .option').each(function(){
			table_html += '<tr><th>'+$(this).text()+'</th><td></td></tr>';
			object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
		});		
				
		table_html += "</table>";
		object.find('.li_handle').append(table_html);
	}	
	
	update_content();

}