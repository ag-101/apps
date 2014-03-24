module ApplicationHelper
  def app_types
    app_types = [['Data capture', 1], ['Data capture with workflow', 2]]
    app_types << ['Custom', 99] if check_role 'top_banana'
    app_types
  end  
  
  def add_breadcrumb_item(name, url, options={})
    breadcrumb = {}
    breadcrumb[name] = { :url => url}
    @breadcrumbs.merge! breadcrumb
  end
  
  def version
    @version = WorkflowContent.where('comment LIKE "[0.%" or comment LIKE "[1.%"').order('comment DESC').limit(1)
    if @version.count > 0
      @version.first.comment.split(']')[0][1..-1] rescue "0"
    else
      "0"
    end
  end
  
  def breadcrumbs
    @breadcrumbs = {}
    
    enhanced_role = true if check_role 'admin' or check_role 'view', 0 or check_role 'create', 0
    
    add_breadcrumb_item(t('text.apps'), apps_path) if enhanced_role
    
    add_breadcrumb_item(enhanced_role ? @app.name : 'Home', app_path(@app)) if @app and !@new_app
    add_breadcrumb_item(t('text.new'), new_app_path) if @new_app
    
    add_breadcrumb_item(t('text.forms'), app_forms_path) if params[:controller] == 'apps/forms' and check_role 'admin'
    add_breadcrumb_item(@apps_construct.name, app_form_path(@app, @apps_construct)) if @apps_construct and !@submissions and !@new_form
    add_breadcrumb_item(t('text.new'), new_app_form_path(@app)) if @new_form
    
    
    add_breadcrumb_item(t('text.submissions'), app_submissions_select_path) if params[:controller] == 'apps/submissions'
    add_breadcrumb_item(@apps_construct.name, app_form_submissions_path(@app, @apps_construct)) if @apps_construct and @submissions

    add_breadcrumb_item(t('text.permissions'), @app ? role_path(@app) : roles_path) if params[:controller] == 'roles'
    
    add_breadcrumb_item(t('text.workflows'), app_workflows_path) if params[:controller] == 'apps/workflows'
    add_breadcrumb_item(@workflow.name, app_workflow_path(@app, @workflow)) if @workflow  and !@new_workflow
    add_breadcrumb_item(t('text.new'), new_app_workflow_path) if @new_workflow
    
    add_breadcrumb_item(@submission.construct.name, app_form_submissions_path(@app, @submission.construct.workflow)) if @submission
    add_breadcrumb_item("#{t('text.submission')} by #{@submission.created_by.name}", root_path) if @submission
    
    add_breadcrumb_item(t('text.help'), helps_path) if params[:controller] == 'helps'


    content_tag :ol, :class=>'breadcrumb' do
      @breadcrumbs.each_with_index do |(k,v), index|
        concat (content_tag :li do
          finished = (index+1 == @breadcrumbs.size) ? k : link_to(k, v[:url], :class=>'')
        end)
      end
    end
  end
  
  def nav_link(link_text, link_path, controller, options={})
    class_name = 'active' if params[:controller] == controller and !options[:construct] and @active_enabled

    if options[:construct] and params[:id].to_i == options[:construct].id and params[:app_id].to_i == options[:construct].app_id
      class_name = 'active'
      @active_enabled = false
    end
    
    class_name = "#{class_name} right" if link_path == helps_path

    content_tag(:li, :class=>class_name) do
      link_to link_text, link_path, :class=>options[:class] || 'standard'
    end
  end

  def title
    (@app and @app.id) ? (link_to @app.name? ? @app.name : 'Apps'.html_safe, app_path(@app)) : (link_to t('text.applications'), root_path)
  end
  
  def glyphicon_text(icon, text)
    content_tag(:span, '', :class=>"glyphicon glyphicon-#{icon}") + " #{text}"
  end
  
  def nav
    @active_enabled = true
    content_tag :div, :class=>'nav-tabs-container' do
      content_tag :ul, :class=>'nav nav-tabs' do
        if (@app and @app.id)
          content = nav_link 'Home', "/#{ @app.slug }", 'apps'
          
          @app.constructs.each do |construct|
            content += nav_link construct.name, app_form_path(@app, construct), 'apps/forms', {:construct => construct} if !construct.disabled? and construct.published?
          end
          
          content += nav_link @apps_construct.name, app_form_path(@app, @apps_construct), 'apps/forms', {:construct => @apps_construct} if @apps_construct and !@submissions and !@new_form and (!@apps_construct.published? or @apps_construct.disabled?)
          
          if check_role 'view', @app.id
            content += content_tag :li do
               nested_content = link_to "#{ t('text.admin')} <span class='glyphicon glyphicon-chevron-right'></span>".html_safe, '#', :class=>'admin_button'               
               nested_content += nav_link glyphicon_text('wrench', t('text.forms')), app_forms_path(@app), 'apps/forms', {:class=>'admin_link'}
               nested_content += nav_link glyphicon_text('stats', t('text.submissions')), app_submissions_select_path(@app), 'apps/submissions', {:class=>'admin_link'}          
               nested_content += nav_link glyphicon_text('thumbs-up', t('text.permissions')), role_path(@app.id), 'roles', {:class=>'admin_link'} if check_role 'admin', @app.id
               nested_content += nav_link glyphicon_text('tasks', t('text.workflows')), app_workflows_path(@app), 'apps/workflows', {:class=>'admin_link'} if @app.app_type == 2
               nested_content
            end         
          end


        else
          content = nav_link t('text.Home'), root_path, 'homes'
          content += nav_link t('text.Apps'), apps_path, 'apps' if check_role 'admin', 0, true or check_role 'create'
          content += nav_link t('text.Permissions'), roles_path, 'roles' if check_role 'top_banana'

        end
        content += nav_link glyphicon_text('question-sign', t('text.help')), helps_path, 'helps'
        content
      end
    end
  end
  
  def button_icon_link(icon, text, path, class_name='', options={})
    options[:class] = "btn btn-#{ class_name.blank? ? 'default' : class_name }" unless options[:class]   
    link_to "<span class='glyphicon glyphicon-#{icon}'></span> #{ text }".html_safe, path, options
  end
  
  def button_closer_link(icon, text, path, class_name='', options={})
    options[:class] = "btn btn-#{class_name.blank? ? 'default' : class_name }" unless options[:class]
    link_to "&nbsp;<span class='glyphicon glyphicon-#{icon}'></span> <span class='toggle_text'>#{text}</span>".html_safe, path, options
  end
end
