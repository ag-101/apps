class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  
 # before_filter :authenticate_user!
  before_filter :get_ldap_info
  
  helper_method :check_role, :check_permission
  
  protect_from_forgery
  
    
  def find_app
    @app = App.find_by_id(params[:app_id]) if params[:app_id]
  end
  
  def check_role(role_name, app_id = 0)
    if user_signed_in?
      must_have = Role.where("((name = '#{role_name}' OR name = 'Admin') AND (app_id = #{app_id || 0} OR app_id = 0)) OR name = 'top_banana'")
      have = current_user.roles

      if (must_have & have).count > 0
        return true
      else
        return false
      end 
    end
  end
  
  def check_permission(role_name, check_app = true, app_parent = '', text = '')
    if check_app
      if params[:id]
        if app_parent != ''
          app_parent_check = app_parent.find_by_id(params[:id])
          lookup = app_parent_check.app_id
        else
          lookup = params[:id]
        end
        
        app = App.find(lookup) unless lookup == 0
        app_id = app.id if app
      end
    end
    
    session[:return_to] ||= request.referer
    unless (check_role(role_name, app_id || 0))
      flash[:notice] = text.blank? ? 'You need permission to view that page' : text
      redirect_to session.delete(:return_to)
    end
  end
  
  def get_ldap_info
    if user_signed_in?
      @user = User.find_by_id(current_user.id)
      if @user.email.blank? or @user.name.blank?
        vars = YAML.load_file("#{Rails.root}/config/ldap.yml")[Rails.env]
        ldap = Net::LDAP.new :host => vars["host"],
          :port => 389,
          :auth => {
               :method => :simple
          }
      
        filter = Net::LDAP::Filter.eq("sAMAccountName", current_user.login)
        
        values = ldap.search(:base => vars["base"], :filter => filter)
        unless values.count < 1
          email = values.first[:mail]
          givenname = values.first[:givenname]
          
          
          @user.email = values.first[:mail].first
          @user.name = values.first[:name].first
          @user.save
        end
        
      end
      unless @user.name
        @user.name = @user.login
        @user.save
      end
    end
  end
end
