class WorkflowContent < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"     
  
  has_many :workflows, through: :workflow_stages
  
  belongs_to :workflow_stage
  belongs_to :submission
end
