class WorkflowStage < ActiveRecord::Base
  attr_accessible :created_by_id, :send_to_id, :updated_by_id, :info_only
  has_many :workflow_contents, :dependent => :destroy
  belongs_to :send_to, :class_name => "User"
  
  validates :send_to_id, presence: true
  
  belongs_to :workflow
end
