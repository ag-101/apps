class Submission < ActiveRecord::Base
  attr_accessible :app_id, :content, :created_by_id, :updated_by_id
  
  belongs_to :construct
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"    
  
  validates :content, presence: true  
  
  has_many :workflow_contents
end
