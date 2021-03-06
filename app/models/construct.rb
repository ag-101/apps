class Construct < ActiveRecord::Base
  attr_accessible :app_id, :content, :created_by_id, :name, :updated_by_id, :workflow_id, :message_before, :message_after
  belongs_to :app
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"    
  
  validates :name, length: { minimum: 2 }, presence: true, uniqueness: true
  validates :content, presence: true
  
  has_many :submissions, :dependent => :destroy
  
  belongs_to :workflow
end
