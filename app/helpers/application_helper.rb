module ApplicationHelper
  def app_types
    app_types = [['Data capture', 1], ['Data capture with workflow', 2]]
    app_types << ['Custom', 99] if check_role 'top_banana'
    app_types
  end  
  
  def nav_link(link_text, link_path, controller, options={})
    class_name = 'active' if params[:controller] == controller and !options[:construct] and @active_enabled
    
    if options[:construct] and params[:id].to_i == options[:construct].id and params[:app_id].to_i == options[:construct].app_id
      class_name = 'active'
      @active_enabled = false
    end

    content_tag(:li, :class=>class_name) do
      link_to link_text, link_path, :class=>options[:class] || 'standard'
    end
  end

  def title
    (@app and @app.id) ? (link_to @app.name, app_home_path(@app)) : (link_to "Applications", root_path)
  end
  
  def nav
    @active_enabled = true
    content_tag :div, :class=>'nav-tabs-container' do
      content_tag :ul, :class=>'nav nav-tabs' do
        if (@app and @app.id)
          content = nav_link @app.name, "/#{ @app.slug }", 'apps'
          
          @app.constructs.each do |construct|
            content += nav_link construct.name, app_form_path(@app, construct), 'apps/forms', {:construct => construct} if !construct.disabled? and construct.published?
          end
          
          if check_role 'admin', @app.id
            content += content_tag :li do
               nested_content = link_to 'Admin <span class="glyphicon glyphicon-chevron-right"></span>'.html_safe, '#', :class=>'admin_button'
               
               nested_content += nav_link 'Forms', app_forms_path(@app), 'apps/forms', {:class=>'admin_link'}
               nested_content += nav_link 'Responses', app_submissions_select_path(@app), 'apps/submissions', {:class=>'admin_link'}          
               nested_content += nav_link 'Permissions', role_path(@app.id), 'roles', {:class=>'admin_link'}
            end         
          end

          content
        else
          content = nav_link 'Home', root_path, 'homes'
          content += nav_link 'Apps', apps_path, 'apps'
          content += nav_link 'Permissions', roles_path, 'roles' if check_role 'top_banana'
          content
        end
      end
    end
  end
end
