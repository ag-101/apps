class WorkflowStage < ActiveRecord::Base
  attr_accessible :created_by_id, :send_to_id, :updated_by_id
  has_many :workflow_content, :dependent => :destroy
  belongs_to :send_to, :class_name => "User"
  
  validates :send_to_id, presence: true

end
