class Apps::ConstructsController < ApplicationController
  
  before_filter :find_app 
  
  # GET /apps/constructs
  # GET /apps/constructs.json
  def index
    @apps_constructs = Construct.where("app_id = #{ params[:app_id] }")
    

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
    @apps_construct = Construct.new

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
        format.html { redirect_to app_constructs_path(params[:app_id]), notice: 'Construct was successfully created.' }
        format.json {  }
      else
        format.html { render action: "new" }
        format.json {  }
      end
    end
  end

  # PUT /apps/constructs/1
  # PUT /apps/constructs/1.json
  def update
    @apps_construct = Construct.find(params[:id])
    @apps_construct.updated_by_id = current_user.id

    respond_to do |format|
      if @apps_construct.update_attributes(params[:construct])
        format.html { redirect_to app_constructs_path(params[:app_id]), notice: 'Construct was successfully updated.' }
        format.json {  }
      else
        format.html { render action: "edit" }
        format.json {  }
      end
    end
  end

  # DELETE /apps/constructs/1
  # DELETE /apps/constructs/1.json
  def destroy
    @apps_construct = Construct.find(params[:id])
    @apps_construct.destroy

    respond_to do |format|
      format.html { redirect_to app_constructs_path(params[:app_id]), notice: 'Construct was successfully deleted.'}
      format.json { head :no_content }
    end
  end
end
