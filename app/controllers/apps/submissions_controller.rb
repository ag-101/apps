class Apps::SubmissionsController < ApplicationController
  def submissions_select
    @app = App.find_by_id(params[:app_id])
  end
  
  def index
    @submissions = Submission.where('construct_id = ?', params[:form_id]).order('created_at DESC').page(params[:page]).per(10)
    @app = App.find_by_id(params[:app_id])

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
    end
  end  
end
