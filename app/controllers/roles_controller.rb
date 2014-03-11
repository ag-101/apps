class RolesController < ApplicationController

  before_filter :authenticate_user!
  
  before_filter lambda { check_permission('admin', true) }
  
  # GET /roles
  # GET /roles.json
  def index    
    @roles = Role.all
    @users = User.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end
  
  def index_app
    @app = App.find_by_id(params[:id])
    @roles = Role.where("app_id = #{ params[:id] }")
    @users = User.find(:all, :order => "name")

    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @roles }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    session[:return_to] ||= request.referer
    role = Role.find(params[:role])
    user = User.find(params[:user])
    
    if params[:add] or params[:remove]
      if params[:add]
        if role.users << user
          redirect_to role.app_id == 0 ? roles_path : role_path(role.app_id), :notice => "<strong>#{ user.name }</strong> now has <strong>#{ role.name.humanize }</strong> role".html_safe
        else
          redirect_to role.app_id == 0 ? roles_path : role_path(role.app_id), :alert => "There was an error giving <strong>#{ user.name }</strong> the role <strong>#{ role.name.humanize }</strong>".html_safe
        end
      end
      
      if params[:remove]
        if role.users.delete(user)
          redirect_to role.app_id == 0 ? roles_path : role_path(role.app_id), :notice => "<strong>#{ user.name }</strong> no longer has <strong>#{ role.name.humanize }</strong> role".html_safe
        else
          redirect_to role.app_id == 0 ? roles_path : role_path(role.app_id), :alert => "There was an error removing the role <strong>#{ role.name.humanize }</strong> from <strong>#{ user.name }</strong>".html_safe
        end
      end
    else
      redirect_to role.app_id == 0 ? roles_path : role_path(role.app_id), :alert => "Unspecified error"
    end
  end
end
