class Apps::WorkflowContentController < ApplicationController

   before_filter :authenticate_user!
   before_filter :find_app 
   
   before_filter :check_approval_status
   before_filter lambda { check_permission('admin', true) }

  def check_approval_status
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    allowed = false
    allowed = true if @workflow_content.status == 'pending' && @workflow_content.workflow_stage.send_to == current_user
    redirect_to app_form_submissions_path(@app, params[:form_id]), :notice=>"#{t('text.not_your_turn')}" unless allowed
    return false
  end

  def approve
    
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    @apps_construct = @workflow_content.submission.construct
    @submission = @workflow_content.submission

  end
  
  def reject
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    @apps_construct = Construct.find_by_id(params[:form_id])
    @submission = @workflow_content.submission
  end
  
  def update
    response = ""
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    @submission = Submission.find_by_id(params[:submission_id])
    
    if @workflow_content.update_attributes(params[:workflow_content])
      response = "#{t('text.submission')} #{ @workflow_content.status }"
      
      create_workflow_stage_content(@submission)
    else
      response = t('text.error_saving_update')
    end
    
    redirect_to app_form_submissions_path(@app, params[:form_id]), :notice=>"#{response}"
  
    
  end

end
