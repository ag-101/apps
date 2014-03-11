class Apps::WorkflowStagesController < ApplicationController

   before_filter :authenticate_user!
   before_filter :find_app 
  
   before_filter lambda { check_permission('admin', true) }

  # GET /apps
  # GET /apps.json
  def index  
    @workflows = Workflow.where('app_id = ?', @app.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end
  
  def new
    @workflow_stage = WorkflowStage.new

    
    respond_to do |format|
      format.html { render layout: false}
      format.json { render json: @workflow }
    end    
  end
  
  def edit

  end  
  
  def destroy
    @workflow_stage = WorkflowStage.find(params[:id])
    @workflow_stage.destroy
    
    @workflow = Workflow.find(params[:workflow_id])
    
    update_stage_numbers(@workflow)

    respond_to do |format|
      format.html { redirect_to app_workflow_path(params[:app_id], params[:workflow_id]), notice: 'Workflow stage was successfully deleted.'}
      format.json { render :json => { :status => "ok", :message => "Success"} } 
    end
  end
  
  def show 
    @workflow = Workflow.find_by_id(params[:id])
  end
    
  def create
    @app = App.find_by_id(params[:app_id])
    @workflow = Workflow.find_by_id(params[:workflow_id])
    @workflow_stage = WorkflowStage.new(params[:workflow_stage])
    @workflow_stage.workflow_id = @workflow.id
    @workflow_stage.created_by_id = current_user.id
    @workflow_stage.updated_by_id = current_user.id

    respond_to do |format|
      if @workflow_stage.save
        update_stage_numbers(@workflow)
        format.html { redirect_to app_workflow_path(params[:app_id], @workflow), notice: 'Workflow stage was successfully created.' }
        format.json {  }
      else
        format.html { render action: "new" }
        format.json {  }
      end
    end
  end  
  
  def update_stage_numbers(workflow)
    @workflow_stages = WorkflowStage.where('workflow_id = ?', workflow.id).order('ISNULL(stage), stage ASC')
    
    @workflow_stages.each_with_index do |workflow_stage, index|
      workflow_stage.stage = (index+1)
      workflow_stage.save
    end
    
  end

end
