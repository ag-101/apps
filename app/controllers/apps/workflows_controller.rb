class Apps::WorkflowsController < ApplicationController

  before_filter :authenticate_user!
    before_filter :find_app 
  
#  before_filter lambda { check_permission('create') }, :only => [:new]
#  before_filter lambda { check_permission('edit') }, :only => [:edit]
#  before_filter lambda { check_permission('delete') }, :only => [:destroy]
#  before_filter lambda { check_permission('view') }, :only => [:show]

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
    @workflow = Workflow.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workflow }
    end    
  end
  
  def edit

  end  
  
  
  
  def show 
    @workflow = Workflow.find_by_id(params[:id])
    @workflow_stages = WorkflowStage.where('workflow_id = ?', @workflow.id)
  end
    
  def create
    @app = App.find_by_id(params[:app_id])
    @workflow = Workflow.new(params[:workflow])
    @workflow.app_id = @app.id
    @workflow.created_by_id = current_user.id
    @workflow.updated_by_id = current_user.id

    respond_to do |format|
      if @workflow.save
        format.html { redirect_to app_workflow_path(params[:app_id], @workflow), notice: 'Workflow was successfully created.' }
        format.json {  }
      else
        format.html { render action: "new" }
        format.json {  }
      end
    end
  end  

end
