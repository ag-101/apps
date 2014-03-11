class Apps::FormsController < ApplicationController
    
  before_filter :authenticate_user!
  before_filter :find_app 
  
  before_filter lambda { check_permission('create', true) }, :only => [:new]
  before_filter lambda { check_permission('edit', true) }, :only => [:edit]
  before_filter lambda { check_permission('delete', true) }, :only => [:destroy]
  before_filter lambda { check_permission('view', true) }, :only => [:show, :index]  
  
  def swap_disabled_status
    @apps_construct = Construct.find(params[:id])
    
    if @apps_construct.disabled?
      @apps_construct.disabled = false
    else
      @apps_construct.disabled = true
    end

    if @apps_construct.save
      redirect_to app_forms_path(params[:app_id])
    end
  end
  
  def success
    @apps_construct = Construct.find_by_id(params[:id])
  end
  
  def save
    @submission = Submission.new()
    @submission.content = params[:content]
    @submission.construct_id = params[:form_id]
    @submission.created_by_id = current_user.id
    @submission.updated_by_id = current_user.id

    if @submission.construct.published?
      if @submission.save
        
        additional_info = ''
        
        if @submission.construct.app.app_type == 2 and @submission.construct.workflow    # start workflow
          additional_info = create_workflow_stage_content(@submission)
        end
        redirect_to success_app_form_path(@submission.construct.app, @submission.construct), notice: "Your response to form '#{ @submission.construct.name }' has been saved.  #{additional_info}"
      else
        redirect_to app_path(params[:app_id]), alert: "There has been an error saving your response"
      end
    else
       redirect_to app_path(params[:app_id]), alert: "The form '#{ @submission.construct.name }' has not yet been published."  
    end
  end
  
  def submissions
    @submissions = Submission.where('construct_id = ?', params[:form_id]).order('created_at DESC')
  end
  
  def submission
    
  end
  
  def publish
    @apps_construct = Construct.find(params[:id])
    
    @apps_construct.published = true

    if @apps_construct.save
      redirect_to app_forms_path(params[:app_id])
    end
  end  
  
  # GET /apps/constructs
  # GET /apps/constructs.json
  def index
    @apps_constructs = Construct.where("app_id = #{ params[:app_id] }").order('name')
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps_constructs }
    end
  end

  # GET /apps/constructs/1
  # GET /apps/constructs/1.json
  def show
    require 'json' 
    @apps_construct = Construct.find(params[:id])
    @use_form = true
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apps_construct }
    end
  end

  # GET /apps/constructs/new
  # GET /apps/constructs/new.json
  def new
    @apps_construct = (flash[:construct]) ? flash[:construct] : Construct.new
    @new_form = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apps_construct }
    end
  end

  # GET /apps/constructs/1/edit
  def edit
    @apps_construct = Construct.find(params[:id])
  end

  # POST /apps/constructs
  # POST /apps/constructs.json
  def create

    @apps_construct = Construct.new(params[:construct])
    @apps_construct.app_id = params[:app_id]
    @apps_construct.created_by_id = current_user.id
    @apps_construct.updated_by_id = current_user.id

    respond_to do |format|
      if @apps_construct.save
        format.html { redirect_to app_forms_path(params[:app_id]), notice: 'Construct was successfully created.' }
        format.json {  }
      else
        flash[:construct] = @apps_construct
        format.html { redirect_to new_app_form_path }
        format.json {  }
      end
    end
  end

  # PUT /apps/constructs/1
  # PUT /apps/constructs/1.json
  def update
    @apps_construct = Construct.find(params[:id])
    
    if @apps_construct.published?
      redirect_to app_forms_path(params[:app_id]), alert: "<strong>'#{@apps_construct.name}'</strong> has already been published and can't now be updated.".html_safe
    else
      @apps_construct.updated_by_id = current_user.id
  
      respond_to do |format|
        if @apps_construct.update_attributes(params[:construct])
          format.html { redirect_to app_forms_path(params[:app_id]), notice: 'Construct was successfully updated.' }
          format.json {  }
        else
          format.html { render action: "edit" }
          format.json {  }
        end
      end      
    end
  end

  # DELETE /apps/constructs/1
  # DELETE /apps/constructs/1.json
  def destroy
    @apps_construct = Construct.find(params[:id])
    @apps_construct.destroy

    respond_to do |format|
      format.html { redirect_to app_forms_path(params[:app_id]), notice: 'Construct was successfully deleted.'}
      format.json { head :no_content }
    end
  end
  
end
