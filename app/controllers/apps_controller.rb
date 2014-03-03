class AppsController < ApplicationController

  before_filter :authenticate_user!
  
  before_filter lambda { check_permission('create') }, :only => [:new]
  before_filter lambda { check_permission('edit') }, :only => [:edit]
  before_filter lambda { check_permission('delete') }, :only => [:destroy]
  before_filter lambda { check_permission('view') }, :only => [:show]

  # GET /apps
  # GET /apps.json
  def index  
    @apps = App.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end
    
  # GET /apps/1
  # GET /apps/1.json
  def show
    home_checks params[:url]
    @app = App.find_by_id(params[:id])
    if !@app
      redirect_to root_path
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end
  
  def route  
    home_checks params[:url]
    render :action => @action
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new
    @new_app = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(params[:app])
    @app.created_by_id = current_user.id
    @app.updated_by_id = current_user.id
    @app.slug = params[:app][:name].parameterize

    respond_to do |format|
      if @app.save
        home = Home.new
        home.content = "<b>#{@app.name}</b><br><br>If you're seeing this text and are the administrator for this application, you should edit this message."
        home.created_by_id = current_user.id
        home.updated_by_id = current_user.id
        home.app_id = @app.id
        home.save
        
        role_types = ['admin', 'create', 'edit', 'delete', 'view']
     
        role_types.each do |rt|
          role = Role.new
          role.name = rt
          role.app_id = @app.id
          role.save  
          
          if rt == 'admin'           
            role = Role.find(role.id)
            role.users << current_user            
          end
        end
      
        format.html { redirect_to @app, notice: 'App was successfully created.' }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: "new" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = App.find(params[:id])
    @app.updated_by_id = current_user.id
    @app.slug = params[:app][:name].parameterize    

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end
end
