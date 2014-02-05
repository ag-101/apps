class Construct < ActiveRecord::Base
  attr_accessible :app_id, :content, :created_by_id, :name, :updated_by_id
  belongs_to :app
  
  validates :name, length: { minimum: 2 }, presence: true, uniqueness: true
  validates :content, presence: true
  
end
