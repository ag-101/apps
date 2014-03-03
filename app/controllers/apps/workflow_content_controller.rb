class Apps::WorkflowContentController < ApplicationController

   before_filter :authenticate_user!
   before_filter :find_app 
  
#  before_filter lambda { check_permission('create') }, :only => [:new]
#  before_filter lambda { check_permission('edit') }, :only => [:edit]
#  before_filter lambda { check_permission('delete') }, :only => [:destroy]
#  before_filter lambda { check_permission('view') }, :only => [:show]

  def approve
    response = ""
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    @submission = Submission.find_by_id(params[:submission_id])
    @workflow_content.status = 'approved'
    if @workflow_content.save
      response = 'Response approved'
      
      create_workflow_stage_content(@submission)
      
    end
    
    redirect_to app_form_submissions_path(@app, params[:form_id]), :notice=>"#{response}"
  end
  
  def reject
    response = ""
    @workflow_content = WorkflowContent.find_by_id(params[:id])
    @submission = Submission.find_by_id(params[:submission_id])
    @workflow_content.status = 'rejected'
    if @workflow_content.save
      response = 'Response rejected'
      
     # create_workflow_stage_content(@submission)
      
    end
    
    redirect_to app_form_submissions_path(@app, params[:form_id]), :notice=>"#{response}"
  end

end
