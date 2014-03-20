class Apps::SubmissionsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :find_app
 
  before_filter lambda { check_permission('view', true) }, :except => [:edit, :show]
  
  def submissions_select

  end
  
  def csv
    @submissions = Submission.joins(:construct).where('draft != 1 AND construct_id = ?', params[:form_id])
    
    require 'csv'
    
    respond_to do |format|        
      format.csv { render :layout => false }
    end
  end
  
  def index
    @submissions = Submission.where('construct_id = ?', params[:form_id]).order('created_at DESC').page(params[:page]).per(10)
    @app = App.find_by_id(params[:app_id])
    @apps_construct = Construct.find_by_id(params[:form_id])

    respond_to do |format|
      format.html
    end
  end
  
  def update
    @submission = Submission.find(params[:id])
    @submission.content = params[:content]
    @submission.draft = params[:draft]
    @submission.updated_by_id = current_user.id

    if @submission.created_by == current_user
      save_response(@submission, 'update')
    else
      redirect_to app_form_submission_path(@app, @submission.construct, @submission), :notice => 'Only the original creator can modify this form.'
    end
  end
  
  def edit
    @submission = Submission.find_by_id(params[:id])
    
    unless current_user == @submission.created_by or check_role 'view', @app.id
      redirect_to root_path, :notice => 'You need permission to view that page.'
      return false
    end
    
    if @submission.created_by != current_user
      redirect_to app_form_submission_path(@app, @submission.construct, @submission), :notice => 'Only the original creator can modify this form.'
    end
    
    if !@submission.draft?
      redirect_to app_form_submission_path(@app, @submission.construct, @submission), :notice => 'This form is no longer in draft mode and so cannot be edited.'
    end
    
    @use_form = true
  end

  def show
    @submission = Submission.find_by_id(params[:id])
    
    unless current_user == @submission.created_by or check_role 'view', @app.id
      redirect_to root_path, :notice => 'You need permission to view that page.'
      return false
    end    
    
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
