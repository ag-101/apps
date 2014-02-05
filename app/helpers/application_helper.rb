module ApplicationHelper
  def app_types
    app_types = [['Data capture', 1], ['Data capture with workflow', 2]]
    app_types << ['Custom', 99] if check_role 'top_banana'
    app_types
  end  
  
  def nav_link(link_text, link_path, controller, a_class = 'standard')   
    class_name = 'active' if params[:controller] == controller
  
    content_tag(:li, :class=>class_name) do
      link_to link_text, link_path, :class=>a_class
    end
  end
    
  def title
    (@app and @app.id) ? (link_to @app.name, app_home_path(@app)) : (link_to "Applications", root_path)
  end
  
  def nav
    content_tag :div, :class=>'nav-tabs-container' do
      content_tag :ul, :class=>'nav nav-tabs' do
        if (@app and @app.id)
          content = nav_link @app.name, "/#{ @app.slug }", 'apps'
          content += nav_link 'Build', app_constructs_path(@app), 'apps/constructs' if check_role 'admin', @app.id          
          content += nav_link 'Permissions', role_path(@app.id), 'roles' if check_role 'admin', @app.id
          content += nav_link 'Admin', app_path(@app), 'homes', 'alt' if check_role 'admin', @app.id
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
