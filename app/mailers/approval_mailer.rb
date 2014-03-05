class ApprovalMailer < ActionMailer::Base
  default from: "noreply@bthft.nhs.uk"
  
  def approval_email(to, submission)
    @submission = submission
    @to = to
    
    mail(from: "\"#{submission.created_by.name}\" <#{submission.created_by.email}>", to: @to.email, subject: "#{submission.construct.app.name}: #{submission.construct.name}")
  end
  
  def info_email(submission) 
    @submission = submission        
    to = Array.new()    
    to.push("\"#{submission.created_by.name}\" <#{submission.created_by.email}>")
    
    submission.workflow_contents.each do |workflow_content|
       to.push("\"#{workflow_content.updated_by.name}\" <#{workflow_content.updated_by.email}>") unless workflow_content.workflow_stage.send_to == submission.created_by
    end
    
    to = to.uniq
    
    @current_status = submission.workflow_contents.last.status
         
    mail(from: "\"#{submission.created_by.name}\" <#{submission.created_by.email}>", to: to, subject: "#{submission.construct.app.name}: #{submission.construct.name}")
  end
end
