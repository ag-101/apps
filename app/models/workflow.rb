class Workflow < ActiveRecord::Base
  attr_accessible :created_by_id, :name, :updated_by_id
  has_many :workflow_stages, :dependent => :destroy
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"     
  
  validates :name, length: { minimum: 2 }, presence: true, uniqueness: true
  belongs_to :app
  has_many :constructs
end
