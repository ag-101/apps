class Home < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"   
  
  belongs_to :apps
end
