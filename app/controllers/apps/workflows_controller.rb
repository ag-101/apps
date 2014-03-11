class Apps::WorkflowsController < ApplicationController

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
    @workflow = (flash[:workflow]) ? flash[:workflow] : Workflow.new
    @new_workflow = true
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workflow }
    end    
  end
  
  def edit

  end  
  
  
  
  def show 
    @workflow = Workflow.find_by_id(params[:id])
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
        flash[:workflow] = @workflow
        format.html { redirect_to new_app_workflow_path }
        format.json {  }
      end
    end
  end  

end
