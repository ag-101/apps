class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
    
  # before_filter :authenticate_user!
  before_filter :get_ldap_info
  
  helper_method :check_role, :check_permission
  
  protect_from_forgery
  
  def home_checks(url)
    @app = App.find_by_id(params[:id]) unless url
     
    if url
      url = url.split("/") if url
      @app = App.where("slug = '#{url.first}'").first
    end
    
    if @app
      @home = Home.where('app_id = ?', @app.id)      
      @action = 'show'
    end
  end  
  
  def save_response(submission, method = 'save')
    if submission.construct.published?
      saved_to_db = false      
 
      if method == 'save'
        if submission.save
          saved_to_db = true
        end
      else
        if submission.update_attributes(params[:submission])
          saved_to_db = true
        end
      end
      
      if saved_to_db
        
        additional_info = ''
        
        if submission.construct.app.app_type == 2 and submission.construct.workflow and submission.draft != 1   # start workflow
          additional_info = create_workflow_stage_content(submission)
        end
        
        notice = "Your response to form '#{ submission.construct.name }' has been saved.  #{additional_info}"
        
        if submission.draft?
          redirect_to edit_app_form_submission_path(@app, submission.construct, submission), notice: notice
        else
          redirect_to success_app_form_path(@app, submission.construct), notice: notice
        end
      else
        redirect_to app_path(params[:app_id]), alert: "There has been an error saving your response"
      end
    else
       redirect_to app_path(params[:app_id]), alert: "The form '#{ submission.construct.name }' has not yet been published."  
    end
  end    
  
  def create_workflow_stage_content(submission)
    @current_highest = WorkflowStage.joins(:workflow).joins(:workflow_contents).where('workflow_contents.status != ?', 'rejected').where('workflow_contents.submission_id = ?', submission.id).where('workflows.app_id = ?', submission.construct.app.id).where('workflow_stages.workflow_id = ?', submission.construct.workflow_id).order('stage DESC').limit(1)
    
    @current_highest.count > 0 ? next_stage = (@current_highest.first.stage+1) : next_stage = 1
    @workflow_stage = WorkflowStage.joins(:workflow).where('workflows.app_id = ?', submission.construct.app.id).where('workflow_stages.stage = ?', next_stage).where('workflow_stages.workflow_id = ?', submission.construct.workflow_id)
    
    @rejected = WorkflowContent.where('status = ?', 'rejected').where('submission_id = ?', submission.id)
    
    if @workflow_stage.count == 0 or @rejected.count > 0
      ApprovalMailer.info_email(submission).deliver
      return additional_info = 'Workflow completed.'
    
    else 
      @workflow_content = WorkflowContent.new
      @workflow_content.created_by_id = current_user.id
      @workflow_content.updated_by_id = current_user.id
      
      @workflow_content.status = 'pending'
      @workflow_content.submission_id = submission.id
      @workflow_content.workflow_stage_id = @workflow_stage.first.id
      if @workflow_content.save
        
        to = @workflow_content.workflow_stage.send_to
        ApprovalMailer.approval_email(to, submission).deliver
        ApprovalMailer.info_email(submission).deliver

        return additional_info = "It has been sent to #{ @workflow_content.workflow_stage.send_to.name } to review."
    end
    end
  end
  
  def find_app
    @app = App.find_by_id(params[:app_id]) if params[:app_id]
  end
  
  def check_role(role_name, app_id = 0, suppress_app_check = false)
    if user_signed_in?
      (suppress_app_check == true) ? additional = '' : additional = " AND (app_id = #{app_id || 0} OR app_id = 0)"
      must_have = Role.where("((name = '#{role_name}' OR name = 'admin') #{additional}) OR name = 'top_banana'")
      have = current_user.roles

      if (must_have & have).count > 0
        return true
      else
        return false
      end 
    end
  end
  
  def check_permission(role_name, check_app = true, app_parent = '', text = '')
    id = params[:app_id] ? params[:app_id] : params[:id]
    
    if check_app
      if id
        if app_parent != '' and !params[:app_id]
          app_parent_check = app_parent.find_by_id(id)
          lookup = app_parent_check.app_id
        else
          lookup = id
        end
        
        app = App.find(lookup) unless lookup == 0
        app_id = app.id if app
      end
    end
    
    session[:return_to] ||= request.referer
    unless (check_role(role_name, app_id || 0))
      flash[:notice] = text.blank? ? 'You need permission to view that page' : text
      redirect_to session.delete(:return_to) || root_path
    end
  end
  
  def get_ldap_info
    if user_signed_in?
      @user = User.find_by_id(current_user.id)
      if @user.email.blank? or @user.name.blank?
        vars = YAML.load_file("#{Rails.root}/config/ldap.yml")[Rails.env]
        ldap = Net::LDAP.new :host => vars["host"],
          :port => 389,
          :auth => {
               :method => :simple,
               :username => vars["username"],
               :password => vars["password"]
          }
      
        filter = Net::LDAP::Filter.eq("sAMAccountName", current_user.login)
        
        values = ldap.search(:base => vars["base"], :filter => filter)
        unless values.count < 1
          email = values.first[:mail]
          givenname = values.first[:givenname]
          
          
          @user.email = values.first[:mail].first
          @user.name = values.first[:name].first
          @user.save
        end
        
      end
      unless @user.name
        @user.name = @user.login
        @user.save
      end
    end
  end
end
