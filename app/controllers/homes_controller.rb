class HomesController < ApplicationController
  # GET /homes
  # GET /homes.json
  
  before_filter :authenticate_user!, except: [:index]

  before_filter lambda { check_permission('edit', true, Home) }, :only => [:edit]
  
  def index
    @homes = Home.where('app_id = 0 and page_type = "home"')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @homes }
    end
  end
  
  def help
    
  end


  # GET /homes/1/edit
  def edit
    @home = Home.find(params[:id])
  end

  # PUT /homes/1
  # PUT /homes/1.json
  def update
    @home = Home.find(params[:id])
    @home.updated_by = current_user
    
    path = (@home.app_id == 0) ? root_url : app_path(@home.app_id)

    respond_to do |format|
      if @home.update_attributes(params[:home])
        format.html { redirect_to path, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end
end
