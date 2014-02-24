$(document).ready(function(){	
	init_drag();
	
	$(".als-container").als({
		visible_items: 4,
		scrolling_items: 4
	});
	
	$('body').on('click', '.remove_page', function(e){
		$(this).parents('.page').slideUp("fast", function(){
			$(this).remove();
		});
		update_content();
		e.preventDefault();
	});
	
	$('.slideUp').slideUp(0);
	
	$('body').on('change', '.form_show select, .form_show input, .form_show textarea', function(){
		prepare_submission();
	});
	
	prepare_submission();
		
	$('body').on('click', '.page_trigger', function(e){
		var page = $(this).prop('id').split('page_trigger');
		display_page(page[1], "fast");
	});
	
	$('body').on('click', '.page_trigger_pn', function(e){
		if(!$(this).parents('li').hasClass('disabled')){
			id = $('.pagination li.active a').prop('id').split('page_trigger');
	
			if($(this).hasClass('page_trigger_previous')){
				display_page((parseFloat(id[1])-1), "fast");
			} else{
				display_page((parseFloat(id[1])+1), "fast");
			}
		}
	});
	
	$('body').on('click', '.option', function(e){
		$(this).toggle({"width":"0px"}, function(){
			$(this).remove();
		});
		e.preventDefault();
	});
	
	$('body').on('keyup', '.additional_option', function(e){
		update_preview($(this).parents('li'));
	});	
	
	$('body').on('keyup', '.page_name', function(e){
		update_content();
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
	
	$('body').on('click', '#add_page', function(){
		add_page();
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
	
	if($('#construct_content').val()){
		load_content();
	}	
});

function display_page(page, speed){
	
	
	$('.pagination li.active').removeClass('active');
	$('#page_trigger'+page).parents('li').addClass('active');
	
	if(page == 1){
		$('.page_trigger_previous').addClass('disabled');		
		$('.page_trigger_previous').parents('li').addClass('disabled');
	} else{
		$('.page_trigger_previous').removeClass('disabled');
		$('.page_trigger_previous').parents('li').removeClass('disabled');
	}
	
	if(page == $('.page').length){
		$('.validate_form').removeClass('hidden');
		$('.page_trigger_next').addClass('disabled');
		$('.page_trigger_next').parents('li').addClass('disabled');
	} else{
		$('.validate_form').addClass('hidden');
		$('.page_trigger_next').removeClass('disabled');
		$('.page_trigger_next').parents('li').removeClass('disabled');
	}
	$('.page').removeClass('hidden');
	$('.page').slideUp(speed);
	$('#page_'+page).slideDown();
}

function update_content(){
	$('#fields .als-item').removeClass('als-item');
	var construct_content = {};
	var count = 1;
	$('#fields .page').not('.hidden').each(function(){
		var form_content = [];
		$(this).find('.li_handle').each(function(){
			current_item = {};
			current_item.label = $(this).find('h3 .text_content').text();
			if ($(this).find('h3 .required').length > 0){
				current_item.required = true;
			} else{
				current_item.required = false;
			}
			
			$(this).parents('li').find('.additional_option').each(function(){
				
				if(typeof parseFloat($(this).val()) ==='number' && ($(this).val()%1)===0) {
					option_name = $(this).prop('class').split('option_name_');
					current_item[option_name[1]] = parseFloat($(this).val());
					
				} else{
					alert("Value must be an integer.");
					$(this).val('');
					update_preview($(this).parents('li'));
				}
	
			});
			
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
		

		
		page_name = 'page'+count+":"+$(this).find('.page_name').val();
		
		
		construct_content[page_name] = form_content;
		++count;
	});
	
	$('#construct_content').val(JSON.stringify(construct_content));
}

function prepare_submission(){
	var responses = {};  
	
	$('.page').each(function(){
		var page = [];
		$(this).find('.form-group').each(function(){
			type = $(this).prop('class').split(" ");
			
			var item_type = {};
			
			switch(type[1]){
				case "select":
				case "textarea":
					item_type[type[1]] = $(this).find(type[1]).val();
				break;
				case "text_field":
					item_type['text_field'] = $(this).find('input').val();					
				break;
				case "checkbox":
				case "radio":
					var checked = [];
					$(this).find('input[type='+type[1]+']:checked').each(function(){
						checked.push($(this).val());
					});
					item_type[type[1]] = checked;
				break;
				case "table_horizontal":
				case "table_vertical":
					var inputs = [];
					$(this).find('input').each(function(){
						inputs.push($(this).val());
					});
					item_type[type[1]] = inputs;
				break;	
			}
			page.push(item_type);
		});

		responses[$(this).prop('id')] = page;
	});
	
	$('#prepared_submission').val(JSON.stringify(responses));
}

function load_content(){
	pages = JSON.parse($('#construct_content').val());

	var page_count = 1;
	
	$.each(pages, function(p, page) {
		if(page_count > 1){
			add_page();
		}

		$('#page'+page_count).find('.page_name').val(p.substr(p.indexOf(":") + 1));
		
		$.each(page, function(k, object) {
			$.each(object, function(field_type, properties) {
				$('#field_picker .'+field_type).clone().appendTo($('#fields #page'+page_count+' ul'));
				var inserted_id = 'field_'+new Date().getTime();
				$('#fields #page'+page_count+' ul li').last().prop('id', inserted_id);			
				
				$.each(properties, function(key, value) {	
					switch(key){
						case "label":
							$('#'+inserted_id).find('.field_label').val(value).trigger('keyup');
						break;
						case "required":
							if(value == true){
								$('#'+inserted_id).find(" .required_checkbox").prop('checked', true).trigger('change');
							}
						break;
						case "rows":
							$('#'+inserted_id).find('.option_name_rows').val(value);
						break;
						case "columns":
							$('#'+inserted_id).find('.option_name_columns').val(value);
						break;
						case "options":						
							for (var value_option in value){		
								$('#'+inserted_id).find('.options').append($('#'+inserted_id).find('.default_option_display').html());
								if($('#'+inserted_id).find('.options .option').last().find('.option_text').length > 0){
									$('#'+inserted_id).find('.options .option').last().find('.option_text').text(value[value_option]);
								} else{
									$('#'+inserted_id).find('.options .option').last().text(value[value_option]);
								}
							}							
						break;
					}
				}); 
				update_preview($('#'+inserted_id));			
			});
		});	
		++page_count;
	});

	if ($('#fields li').length > 1){
		$('.drop_fields_here').slideUp(0);
	}		
	
	$('#fields .form_controls').fadeIn();	
}

function add_page(){
	var pages = $('.page').length;
	$('.page.hidden').clone().appendTo('#fields .fields_content').removeClass('hidden').prop('id', 'page'+pages);
	$('#fields .page').last().find('label').text('Page '+pages);
	$('#fields .page_name').last().prop('name', 'page_'+pages);
	
	$('#fields .page').last().fadeOut(0, function(){
		$(this).fadeIn();
	});
	
	destroy_drag();
	init_drag();
	update_content();
}

function destroy_drag(){
	$(".edit #field_picker ul li").draggable('destroy');
	//$('.edit #fields ul').droppable('disable');
	//$(".edit #fields ul").sortable('destroy');
}

function init_drag(){
	
	$(".edit #field_picker ul li").draggable({ 
		connectToSortable: '.edit #fields ul',
			helper: 'clone',
			revert: 'invalid',
			opacity: '0.5',
			cursor: 'move',
			tolerance: 'pointer',
			appendTo: '#fields',
			zIndex:5000000,			
	});	
	
	
	$('.edit #fields ul').droppable({
	      activate: function( event, ui ) {
	          $('#fields ul').addClass("alert-warning");
	       //   $(".drop_fields_here").fadeOut("fast");     
	      },
	      deactivate: function( event, ui ) {
	          $('#fields ul.alert-warning').removeClass("alert-warning");
	          $('#fields ul.alert-success').removeClass("alert-success");  
	      },	      
	      over: function( event, ui ) {
	    	  $(this).removeClass("alert-warning");  
	          $(this).addClass("alert-success");  
	      },	
	      out: function( event, ui ) {
	    	  $('#fields ul.alert-success').removeClass("alert-success");
	          $('#fields ul').addClass("alert-warning");  
	      },	      
	      drop: function( event, ui ) {
	    	  ui.draggable.css('left', '0');
	          $('#fields ul.alert-warning').removeClass("alert-warning");
	          $('#fields ul.alert-success').removeClass("alert-success");
	          ui.draggable.effect('highlight', {color:'#dff0d8'});
	          update_content();
	      }	  	      
	});	
	
	
	$(".edit #fields ul").sortable({  
	//	revert:true,  
		connectWith: '.edit #fields ul',
		tolerance: 'pointer', 
	//	items: "li:not(.drop_fields_here)",
		handle: '.li_handle',
		helper: 'clone',
		appendTo: '#fields',
		zIndex:5000000,
		stop: function(event, ui) {

			$(this).find('.remove').not('input[type=text]').not('textarea').fadeTo(1000, 0.3);

			$(".drop_fields_here").slideUp("fast");
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

	switch(object.prop('class').replace('ui-draggable', '').replace(/\s/g, "")){
		case 'table_horizontal':
			object.find('table, .form_save_option').remove();
			
			var table_html = '<table class="table table-striped table-bordered table-hover">';

			
			object.find('.options .option').each(function(){
				columns = "";
				for(var i = 0; i < parseFloat(object.find('.option_name_columns').val()); i++){
					columns += "<td></td>";
				}
				
				table_html += '<tr><th>'+$(this).text()+'</th>'+columns+'</tr>';
				object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
			});		
					
			table_html += "</table>";
			object.find('.li_handle').append(table_html);
		break;
		case 'table_vertical':
			object.find('table, .form_save_option').remove();
			
			
			var table_html = '<table class="table table-striped table-bordered table-hover"><tr>';
			
			object.find('.options .option').each(function(){
				table_html += '<th>'+$(this).text()+'</th>';
				object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
			});		
			table_html += '</tr>';
			
			for(var i = 0; i < parseFloat(object.find('.option_name_rows').val()); i++){
				table_html += '<tr>';
				object.find('.options .option').each(function(){
						table_html += '<td>&nbsp;</td>';
				});	
				table_html += '</tr>';	
			}

			table_html += "</table>";
			object.find('.li_handle').append(table_html);			
		break;
		case 'radio':
		case 'checkbox':
			object.find('.form_save_option, .li_handle .remove, .li_handle input, .li_handle .option_text, .li_handle br').remove();
			object.find('.options .option').each(function(){
				object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).find('.option_text').text()+'">');
				object.find('.li_handle').append($(this).html()+"<br/>");
			});			
		break;
		case 'select':
			object.find('.li_handle select').prop('disabled', false).html('');
			object.find('.form_save_option').remove();
			object.find('.options .option').each(function(){
				object.find('.li_handle').append('<input type="hidden" class="form_save_option" value="'+$(this).text()+'">');
				object.find('.li_handle select').append("<option>"+$(this).text()+"</option>");
			});		
		break;
	}
	update_content();
}



