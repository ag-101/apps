class Apps::SubmissionsController < ApplicationController
  
  before_filter :authenticate_user!
 
  before_filter lambda { check_permission('view', true) }
  
  def submissions_select
    @app = App.find_by_id(params[:app_id])
  end
  
  def index
    @submissions = Submission.where('construct_id = ?', params[:form_id]).order('created_at DESC').page(params[:page]).per(10)
    @app = App.find_by_id(params[:app_id])
    @apps_construct = Construct.find_by_id(params[:form_id])

    respond_to do |format|
      format.html
    end
  end

  def show
    @submission = Submission.find_by_id(params[:id])
    @app = App.find_by_id(params[:app_id])
    @use_form = true

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => "#{ @submission.construct.name } - #{@submission.created_by.name}",
               :layout => 'pdf.html',
               :basic_auth => true
      end      
    end
  end  
end
